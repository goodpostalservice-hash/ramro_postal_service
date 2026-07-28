import 'dart:async';
import 'dart:collection';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/storage/storage_util.dart';
import '../../data/models/map_data_request.dart';
import '../../data/models/map_data_response.dart';
import '../../domain/usecases/get_map_data_usecase.dart';

typedef HouseMarkerTap =
    Future<void> Function(
      LatLng location,
      String? fullAddress,
      String label,
      String? zone,
      String? subZone,
      String markerId,
    );

class HouseMarkerController {
  HouseMarkerController({
    required this.getMapDataUseCase,
    required this.currentZoom,
    this.onMarkerTap,
  });

  // ─── Constants ────────────────────────────────────────────────────────────
  static const int _maxMemoryCacheItems = 30;
  static const int _maxIconCacheItems = 150;
  static const double fetchThreshold = 17.0;
  static const double showThreshold = 20.0;
  static const Duration _debounceDuration = Duration(milliseconds: 350);
  static const Duration _cleanupDelay = Duration(milliseconds: 500);
  static const double _fetchRadiusMultiplier = 1.5;
  static const double _cleanupRadiusMultiplier = 1.6;
  static const int _maxRetries = 2;
  static const int _maxConcurrentIcons = 10;

  // Icon sizing constants
  static const double _baseFontSize = 10.0;
  static const double _paddingX = 5.0;
  static const double _paddingY = 2.5;
  static const double _borderRadius = 4.0;
  static const double _borderWidth = 0.8;

  // ─── Dependencies ─────────────────────────────────────────────────────────
  final GetMapDataUseCase getMapDataUseCase;
  final RxDouble currentZoom;
  final HouseMarkerTap? onMarkerTap;

  // ─── State ────────────────────────────────────────────────────────────────
  GoogleMapController? mapController;
  final Rx<String?> highlightedMarkerId = Rx<String?>(null);

  List<AddressData> _currentVisibleHouses = [];
  bool _isInitialized = false;
  LatLng? _searchTarget;
  String? _initialForcedLabel;
  final Map<String, String> _labelOverrides = {};

  final RxSet<Marker> _markers = <Marker>{}.obs;
  Set<Marker> get markers => _markers;

  final LinkedHashMap<String, List<AddressData>> _memoryCache = LinkedHashMap();
  final LinkedHashMap<String, BitmapDescriptor> _iconCache = LinkedHashMap();

  bool _isFetching = false;
  bool _hasPendingFetch = false;
  int _cleanupVersion = 0;
  Timer? _cameraIdleDebounce;
  LatLng? _lastFetchCenter;
  int? _lastFetchZoomBucket;

  // Pre-computed paints
  late final Paint _normalBgPaint = Paint()
    ..color = Colors.white.withValues(alpha: 0.94);
  late final Paint _highlightedBgPaint = Paint()
    ..color = const Color(0xFF2E7D32);
  late final Paint _borderPaint = Paint()
    ..color = Colors.black.withValues(alpha: 0.18)
    ..style = PaintingStyle.stroke
    ..strokeWidth = _borderWidth;

  final _iconSemaphore = _Semaphore(_maxConcurrentIcons);

  double get _currentFontSize => switch (currentZoom.value) {
    >= 21 => 11.0,
    >= 20 => 10.0,
    >= 19 => 9.5,
    _ => 9.0,
  };

  // ─── Highlight & Render Logic ─────────────────────────────────────────────
  void updateHighlight(String newMarkerId) {
    final oldId = highlightedMarkerId.value;
    if (oldId == newMarkerId) return;

    final zoomKey = _zoomBucket;
    String? oldLabel;
    String? newLabel;

    if (oldId != null) {
      final oldHouse = _currentVisibleHouses.cast<AddressData?>().firstWhere(
        (h) => 'h_${h?.id}' == oldId,
        orElse: () => null,
      );
      if (oldHouse != null) oldLabel = _buildLabel(oldHouse);
    }

    final newHouse = _currentVisibleHouses.cast<AddressData?>().firstWhere(
      (h) => 'h_${h?.id}' == newMarkerId,
      orElse: () => null,
    );
    if (newHouse != null) newLabel = _buildLabel(newHouse);

    if (oldLabel != null) {
      _iconCache.remove('1_${zoomKey}_$oldLabel');
      _iconCache.remove('0_${zoomKey}_$oldLabel');
    }
    if (newLabel != null) {
      _iconCache.remove('1_${zoomKey}_$newLabel');
      _iconCache.remove('0_${zoomKey}_$newLabel');
    }

    // CRITICAL: Clear initial search label overrides so houses revert to real labels
    _labelOverrides.clear();

    highlightedMarkerId.value = newMarkerId;

    if (_currentVisibleHouses.isNotEmpty &&
        currentZoom.value >= showThreshold) {
      _buildMarkersBatch(_currentVisibleHouses);
    }
  }

  Future<void> _renderOrClear(List<AddressData> houses) async {
    if (!_isInitialized) return;

    if (currentZoom.value < showThreshold) {
      if (_markers.isNotEmpty) _markers.clear();
      _currentVisibleHouses = [];
      return;
    }

    // Find the single closest house to the search target (runs only once right after search)
    if (_searchTarget != null) {
      double minDistance = double.infinity;
      String? closestId;

      for (final house in houses) {
        final lat = double.tryParse(house.latitude ?? '') ?? 0.0;
        final lng = double.tryParse(house.longitude ?? '') ?? 0.0;
        if (lat == 0.0 && lng == 0.0) continue;

        final dist = Geolocator.distanceBetween(
          lat,
          lng,
          _searchTarget!.latitude,
          _searchTarget!.longitude,
        );

        if (dist < minDistance) {
          minDistance = dist;
          closestId = 'h_${house.id}';
        }
      }

      // If we found a house reasonably close (e.g., < 50 meters), highlight it and force its label
      if (closestId != null && minDistance < 50.0) {
        highlightedMarkerId.value = closestId;
        if (_initialForcedLabel != null) {
          _labelOverrides[closestId] = _initialForcedLabel!;
        }
      }

      // Consume and clear search state so it doesn't trigger again on normal camera moves
      _searchTarget = null;
      _initialForcedLabel = null;
    }

    _currentVisibleHouses = houses;
    await _buildMarkersBatch(houses);
  }

  // ─── Lifecycle ────────────────────────────────────────────────────────────
  void dispose() {
    _cameraIdleDebounce?.cancel();
    _markers.clear();
    _memoryCache.clear();
    _iconCache.clear();
    _labelOverrides.clear();
    mapController = null;
    highlightedMarkerId.value = null;
    _searchTarget = null;
    _initialForcedLabel = null;
    _isInitialized = false;
  }

  // ─── Public Methods ───────────────────────────────────────────────────────
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _isInitialized = true;

    if (currentZoom.value >= fetchThreshold) {
      fetchHouseNumbersOptimized();
    } else if (currentZoom.value < showThreshold) {
      _markers.clear();
    }
  }

  void onCameraMove(CameraPosition position) {
    currentZoom.value = position.zoom;
    if (position.zoom < showThreshold && _markers.isNotEmpty) {
      _markers.clear();
    }
  }

  void onCameraIdle() {
    if (currentZoom.value < fetchThreshold || !_isInitialized) return;
    _cameraIdleDebounce?.cancel();
    _cameraIdleDebounce = Timer(_debounceDuration, fetchHouseNumbersOptimized);
  }

  Future<void> prepareSearchMap({
    required GoogleMapController controller,
    required LatLng target,
    required String highlightedLabel,
    String? forceLabelForTarget,
  }) async {
    mapController = controller;
    highlightedMarkerId.value = null;
    _labelOverrides.clear(); // Clear old search overrides

    _searchTarget = target;
    _initialForcedLabel = forceLabelForTarget;
    currentZoom.value = 20.0;
    _isInitialized = true;

    _iconCache.clear();
    _memoryCache.clear();
    _lastFetchCenter = null;
    _lastFetchZoomBucket = null;

    await controller.animateCamera(CameraUpdate.newLatLngZoom(target, 20.0));

    await Future.delayed(const Duration(milliseconds: 400));

    await fetchHouseNumbersOptimized();
  }

  Future<void> clearAllCaches() async {
    _memoryCache.clear();
    _iconCache.clear();
    _markers.clear();
    unawaited(SStorageUtil.cleanExpiredHouseCache());
  }

  // ─── Fetch Logic ──────────────────────────────────────────────────────────
  Future<void> fetchHouseNumbersOptimized() async {
    if (_isFetching) {
      _hasPendingFetch = true;
      return;
    }
    if (!_isInitialized || mapController == null) return;

    _isFetching = true;
    try {
      await _fetchHouseNumbersInternal();
    } finally {
      _isFetching = false;
      if (_hasPendingFetch) {
        _hasPendingFetch = false;
        unawaited(fetchHouseNumbersOptimized());
      }
    }
  }

  Future<void> _fetchHouseNumbersInternal() async {
    final controller = mapController;
    if (controller == null) return;

    final zoom = _zoomBucket;
    if (zoom < 17) return;

    final bounds = await controller.getVisibleRegion();
    final center = _boundsCenter(bounds);
    final cacheKey = _gridKey(center, zoom);

    if (center == _lastFetchCenter && zoom == _lastFetchZoomBucket) return;

    final cachedHouses = _memoryCache[cacheKey];
    if (cachedHouses != null) {
      _lastFetchCenter = center;
      _lastFetchZoomBucket = zoom;
      await _renderOrClear(cachedHouses);
      return;
    }

    final hiveHouses = _getFromStorage(cacheKey);
    if (hiveHouses != null) {
      _memoryCache[cacheKey] = hiveHouses;
      _lastFetchCenter = center;
      _lastFetchZoomBucket = zoom;
      await _renderOrClear(hiveHouses);
      return;
    }

    final visibleRadiusKm = _distanceKm(center, bounds.northeast);
    final fetchRadiusKm = visibleRadiusKm * _fetchRadiusMultiplier;

    final request = MapDataRequest(
      zoomLevel: zoom.toDouble(),
      latitude: center.latitude,
      longitude: center.longitude,
      radius: fetchRadiusKm.toStringAsFixed(3),
    );

    MapDataResponse? response;
    for (var retry = 0; retry <= _maxRetries; retry++) {
      if (!_isInitialized) return;

      final result = await getMapDataUseCase(request);
      final success = await result.fold((failure) async {
        if (retry < _maxRetries) {
          await Future.delayed(Duration(milliseconds: 200 * (retry + 1)));
          return null;
        }
        if (!_isDisposed) Get.snackbar('Error', failure.message);
        return null;
      }, (resp) async => resp);

      if (success != null) {
        response = success;
        break;
      }
    }

    if (response == null) return;

    _lastFetchCenter = center;
    _lastFetchZoomBucket = zoom;

    final houses = (response.data ?? []).take(_houseLimit).toList();
    _addToMemoryCache(cacheKey, houses);
    unawaited(_saveToStorage(cacheKey, houses));

    final currentVersion = ++_cleanupVersion;
    await _renderOrClear(houses);

    if (currentZoom.value >= showThreshold && !_isDisposed) {
      _scheduleCleanup(
        center,
        fetchRadiusKm * _cleanupRadiusMultiplier,
        currentVersion,
      );
    }
  }

  // ─── Storage Operations ──────────────────────────────────────────────────
  List<AddressData>? _getFromStorage(String cacheKey) {
    try {
      final cached = SStorageUtil.getHouseCache(cacheKey: cacheKey);
      if (cached == null) return null;

      return cached
          .map(
            (item) => AddressData(
              id: item['id'] as int?,
              latitude: item['lat'] as String?,
              longitude: item['lng'] as String?,
              houseNum: item['num'] as String?,
              zone: item['zone'] as String?,
              subZone: item['sub'] as String?,
              fullAddressDetail: item['addr'] as String?,
            ),
          )
          .toList();
    } catch (e) {
      debugPrint('Storage read failed: $e');
      return null;
    }
  }

  Future<void> _saveToStorage(String cacheKey, List<AddressData> houses) async {
    if (houses.isEmpty) return;
    try {
      final data = houses
          .map(
            (h) => {
              'id': h.id,
              'lat': h.latitude ?? '',
              'lng': h.longitude ?? '',
              'num': h.houseNum ?? '',
              'zone': h.zone ?? '',
              'sub': h.subZone ?? '',
              'addr': h.fullAddressDetail ?? '',
            },
          )
          .toList();

      await SStorageUtil.saveHouseCache(cacheKey: cacheKey, houses: data);
    } catch (e) {
      debugPrint('Storage save failed: $e');
    }
  }

  // ─── Marker Building ──────────────────────────────────────────────────────
  Future<void> _buildMarkersBatch(List<AddressData> houses) async {
    if (houses.isEmpty || !_isInitialized) return;

    final parsedHouses = houses
        .map(_parseHouse)
        .whereType<_ParsedHouse>()
        .toList();
    if (parsedHouses.isEmpty) return;

    final icons = await _generateIconsBatch(parsedHouses);

    final newMarkers = <Marker>{};
    for (var i = 0; i < parsedHouses.length; i++) {
      final icon = icons[i];
      if (icon == null) continue;

      final parsed = parsedHouses[i];
      newMarkers.add(
        Marker(
          markerId: parsed.markerId,
          position: parsed.position,
          alpha: 1.0,
          icon: icon,
          onTap: () => onMarkerTap!(
            parsed.position,
            parsed.fullAddress,
            parsed.label,
            parsed.zone,
            parsed.subZone,
            parsed.markerId.value, // Pass ID
          ),
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }

    _mergeMarkers(newMarkers);
  }

  Future<List<BitmapDescriptor?>> _generateIconsBatch(
    List<_ParsedHouse> houses,
  ) async {
    return Future.wait(
      houses.map((house) async {
        await _iconSemaphore.acquire();
        try {
          return await _getOrCreateIcon(
            house.label,
            isHighlighted: house.isHighlighted,
          );
        } finally {
          _iconSemaphore.release();
        }
      }),
    );
  }

  _ParsedHouse? _parseHouse(AddressData house) {
    final lat = double.tryParse(house.latitude ?? '');
    final lng = double.tryParse(house.longitude ?? '');
    if (lat == null || lng == null || (lat == 0.0 && lng == 0.0)) return null;

    final position = LatLng(lat, lng);
    final markerIdStr = 'h_${house.id}';

    // Check for forced label override (from search)
    var label = _labelOverrides.containsKey(markerIdStr)
        ? _labelOverrides[markerIdStr]!
        : _buildLabel(house);

    if (label.isEmpty) return null;

    // Highlight logic unified: ONLY based on ID
    final isHighlighted = highlightedMarkerId.value == markerIdStr;

    return _ParsedHouse(
      markerId: MarkerId(markerIdStr),
      position: position,
      label: label,
      isHighlighted: isHighlighted,
      fullAddress: house.fullAddressDetail,
      zone: house.zone,
      subZone: house.subZone,
    );
  }

  String _buildLabel(AddressData house) {
    final num = house.houseNum;
    if (num == null || num.isEmpty) return '';
    final subZone = house.subZone;
    if (subZone == null || subZone.isEmpty) return num;
    return '$subZone $num'.trim();
  }

  void _mergeMarkers(Set<Marker> newMarkers) {
    if (newMarkers.isEmpty) return;

    final merged = {for (final m in _markers) m.markerId.value: m};
    for (final marker in newMarkers) {
      merged[marker.markerId.value] = marker;
    }

    _markers.assignAll(merged.values.toSet());
  }

  // ─── Icon Generation ──────────────────────────────────────────────────────
  Future<BitmapDescriptor?> _getOrCreateIcon(
    String number, {
    required bool isHighlighted,
  }) async {
    final cacheKey = '${isHighlighted ? 1 : 0}_${_zoomBucket}_$number';
    final cached = _iconCache[cacheKey];
    if (cached != null) return cached;

    try {
      final descriptor = await _createIcon(number, isHighlighted);
      _addToIconCache(cacheKey, descriptor);
      return descriptor;
    } catch (e) {
      debugPrint('Icon creation failed: $e');
      return null;
    }
  }

  Future<BitmapDescriptor> _createIcon(
    String number,
    bool isHighlighted,
  ) async {
    final textStyle = TextStyle(
      fontSize: isHighlighted ? _currentFontSize + 1.0 : _currentFontSize,
      fontWeight: isHighlighted ? FontWeight.w800 : FontWeight.w700,
      color: isHighlighted ? Colors.white : const Color(0xFF1A1A1A),
      height: 1.0,
      letterSpacing: -0.2,
    );

    final painter = TextPainter(
      text: TextSpan(text: number, style: textStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();

    final width = (painter.width + (_paddingX * 2)).ceil();
    final height = (painter.height + (_paddingY * 2)).ceil();
    if (width <= 0 || height <= 0) return BitmapDescriptor.defaultMarker;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      const Radius.circular(_borderRadius),
    );

    canvas.drawRRect(
      rect,
      isHighlighted ? _highlightedBgPaint : _normalBgPaint,
    );
    canvas.drawRRect(rect, _borderPaint);
    painter.paint(canvas, const Offset(_paddingX, _paddingY));

    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      image.dispose();
      return BitmapDescriptor.defaultMarker;
    }

    final bytes = byteData.buffer.asUint8List();
    image.dispose();

    return BitmapDescriptor.bytes(bytes);
  }

  // ─── Cache Management ─────────────────────────────────────────────────────
  void _addToMemoryCache(String key, List<AddressData> value) {
    if (_memoryCache.containsKey(key)) {
      _memoryCache.remove(key);
    } else if (_memoryCache.length >= _maxMemoryCacheItems) {
      _memoryCache.remove(_memoryCache.keys.first);
    }
    _memoryCache[key] = value;
  }

  void _addToIconCache(String key, BitmapDescriptor value) {
    if (_iconCache.containsKey(key)) {
      _iconCache.remove(key);
    } else if (_iconCache.length >= _maxIconCacheItems) {
      _iconCache.remove(_iconCache.keys.first);
    }
    _iconCache[key] = value;
  }

  // ─── Cleanup ──────────────────────────────────────────────────────────────
  void _scheduleCleanup(LatLng center, double maxDistanceKm, int version) {
    Future.delayed(_cleanupDelay, () {
      if (version != _cleanupVersion || _isDisposed) return;

      final maxDistanceM = maxDistanceKm * 1000;
      final centerLat = center.latitude;
      final centerLng = center.longitude;

      final filtered = _markers.where((marker) {
        final distance = Geolocator.distanceBetween(
          centerLat,
          centerLng,
          marker.position.latitude,
          marker.position.longitude,
        );
        return distance <= maxDistanceM;
      }).toSet();

      if (filtered.length != _markers.length) {
        _markers.assignAll(filtered);
      }
    });
  }

  // ─── Utility Methods ──────────────────────────────────────────────────────
  LatLng _boundsCenter(LatLngBounds bounds) {
    return LatLng(
      (bounds.northeast.latitude + bounds.southwest.latitude) * 0.5,
      (bounds.northeast.longitude + bounds.southwest.longitude) * 0.5,
    );
  }

  String _gridKey(LatLng center, int zoom) {
    final precision = zoom >= 20 ? 4 : 3;
    return '${zoom}_${center.latitude.toStringAsFixed(precision)}_${center.longitude.toStringAsFixed(precision)}';
  }

  int get _zoomBucket => switch (currentZoom.value) {
    >= 21 => 21,
    >= 20 => 20,
    >= 19 => 19,
    >= 18 => 18,
    >= 17 => 17,
    _ => 16,
  };

  int get _houseLimit => switch (currentZoom.value) {
    >= 21 => 20,
    >= 20 => 30,
    >= 19 => 40,
    >= 18 => 30,
    >= 17 => 15,
    _ => 0,
  };

  double _distanceKm(LatLng a, LatLng b) {
    return Geolocator.distanceBetween(
          a.latitude,
          a.longitude,
          b.latitude,
          b.longitude,
        ) /
        1000.0;
  }

  bool get _isDisposed => !_isInitialized;
}

// ─── Semaphore for Concurrency Control ──────────────────────────────────────
class _Semaphore {
  final int maxConcurrent;
  int _current = 0;
  final _waitQueue = <Completer<void>>[];

  _Semaphore(this.maxConcurrent);

  Future<void> acquire() async {
    if (_current < maxConcurrent) {
      _current++;
      return;
    }
    final completer = Completer<void>();
    _waitQueue.add(completer);
    await completer.future;
  }

  void release() {
    if (_waitQueue.isNotEmpty) {
      final next = _waitQueue.removeAt(0);
      next.complete();
    } else {
      _current--;
    }
  }
}

// ─── Helper Class ───────────────────────────────────────────────────────────
class _ParsedHouse {
  final MarkerId markerId;
  final LatLng position;
  final String label;
  final bool isHighlighted;
  final String? fullAddress;
  final String? zone;
  final String? subZone;

  const _ParsedHouse({
    required this.markerId,
    required this.position,
    required this.label,
    required this.isHighlighted,
    this.fullAddress,
    required this.zone,
    required this.subZone,
  });
}
