import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/search_request.dart';
import '../../data/models/search_response.dart';
import '../../domain/usecases/get_search_result_usecase.dart';

class SearchAddressController extends GetxController {
  // USECASE_FIELDS_START
  final GetSearchResultUseCase getSearchResultUseCase;
  // USECASE_FIELDS_END

  SearchAddressController({
    // USECASE_CONSTRUCTOR_START
    required this.getSearchResultUseCase,
    // USECASE_CONSTRUCTOR_END
  });

  final RxList<SearchAddress> searchHistoryList = <SearchAddress>[].obs;
  final TextEditingController searchController = TextEditingController();

  final isLoading = false.obs;
  Timer? _debounce;
  final RxList<SearchAddress> ramroResultList = <SearchAddress>[].obs;
  final RxList<SearchAddress> googleResultList = <SearchAddress>[].obs;
  final String _googleApiKey = dotenv.get('GOOGLE_MAP_API_KEY');
  static const String _searchHistoryBox = 'search_history_box';
  static const String _searchHistoryKey = 'search_history';

  // API_METHODS_START
  // API_METHODS_END

  @override
  void onInit() {
    super.onInit();
    loadSearchHistory();
  }

  Future<Box> _openHistoryBox() async {
    if (Hive.isBoxOpen(_searchHistoryBox)) {
      return Hive.box(_searchHistoryBox);
    }
    return await Hive.openBox(_searchHistoryBox);
  }

  void onSearchChanged(String query) {
    ramroResultList.clear();
    googleResultList.clear();

    if (query.trim().isEmpty) {
      isLoading.value = false;
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performConcurrentSearch(query);
    });
  }

  Future<void> _performConcurrentSearch(String query) async {
    isLoading.value = true;

    try {
      final ramroRequest = SearchRequest(query: query);

      final results = await Future.wait([
        fetchRamro(ramroRequest),
        _fetchGooglePlaces(query),
      ]);

      ramroResultList.assignAll(results[0]);
      googleResultList.assignAll(results[1]);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  List<SearchAddress> getCombinedSortedResults() {
    final combined = [...ramroResultList, ...googleResultList];
    final query = searchController.text.toLowerCase().trim();

    if (query.isEmpty) return combined;

    bool isRamro(SearchAddress item) {
      return item.isRamro;
    }

    int getMatchLevel(SearchAddress item) {
      final addr = (item.fullAddressDetail ?? '').toLowerCase();
      if (addr.startsWith(query)) return 0;
      if (addr.contains(query)) return 1;
      return 2;
    }

    combined.sort((a, b) {
      final aIsRamro = isRamro(a);
      final bIsRamro = isRamro(b);

      final aMatch = getMatchLevel(a);
      final bMatch = getMatchLevel(b);

      final aMatches = aMatch <= 1;
      final bMatches = bMatch <= 1;

      if (aMatches && bMatches) {
        if (aIsRamro && !bIsRamro) {
          return -1; // A is Ramro, B is Google -> A wins
        }
        if (!aIsRamro && bIsRamro) {
          return 1; // B is Ramro, A is Google -> B wins
        }
      }

      if (aMatches && !bMatches) return -1;
      if (!aMatches && bMatches) return 1;

      if (aMatch != bMatch) return aMatch.compareTo(bMatch);

      return 0; // Keep original order if everything is equal
    });

    return combined;
  }

  Future<List<SearchAddress>> fetchRamro(SearchRequest request) async {
    final result = await getSearchResultUseCase(request);
    return result.fold((failure) => [], (response) => response.data);
  }

  Future<List<SearchAddress>> _fetchGooglePlaces(String query) async {
    var dio = Dio();
    try {
      final uri =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_googleApiKey&components=country:np";

      var googleResponse = await dio.get(uri);

      if (googleResponse.data['status'] == 'OK') {
        final predictions = googleResponse.data['predictions'] as List;

        return predictions.map((pred) {
          // 2. Safely extract the place_id as a String
          final String? placeId = pred['place_id'];

          return SearchAddress(
            fullAddressDetail: pred['description'] ?? 'Unknown Address',
            placeId: placeId,
            source: SearchAddressSource.google,
          );
        }).toList();
      }

      return [];
    } catch (e) {
      print('Google Places API Error: $e');
      return [];
    }
  }

  // Fetch Lat/Lng for a specific Google Place ID
  Future<SearchAddress?> getGooglePlaceDetails(String placeId) async {
    var dio = Dio();
    try {
      final uri =
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_googleApiKey";
      var response = await dio.get(uri);

      if (response.data['status'] == 'OK') {
        final location = response.data['result']['geometry']['location'];

        return SearchAddress(
          latitude: location['lat'].toString(),
          longitude: location['lng'].toString(),
          fullAddressDetail: response.data['result']['formatted_address'],
          placeId: placeId,
          source: SearchAddressSource.google,
        );
      }
    } catch (e) {
      print('Google Place Details Error: $e');
    }
    return null;
  }

  Future<void> loadSearchHistory() async {
    final box = await _openHistoryBox();

    final history = box.get(_searchHistoryKey, defaultValue: []);

    /// Clear old string-based history automatically
    if (history is List && history.isNotEmpty && history.first is String) {
      await box.delete(_searchHistoryKey);
      searchHistoryList.clear();
      return;
    }

    final list = (history as List)
        .map((e) => SearchAddress.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    searchHistoryList.assignAll(list.take(3).toList());
  }

  Future<void> saveSearchHistory(SearchAddress address) async {
    final box = await _openHistoryBox();

    final history = box.get(_searchHistoryKey, defaultValue: []);

    List<Map<String, dynamic>> list = [];

    if (history is List) {
      list = history
          .whereType<Map>()
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    list.removeWhere((item) {
      return item['id'] == address.id ||
          item['full_address_detail'] == address.fullAddressDetail;
    });

    list.insert(0, address.toJson());

    final latestThree = list.take(3).toList();

    await box.put(_searchHistoryKey, latestThree);

    searchHistoryList.assignAll(
      latestThree.map((e) => SearchAddress.fromJson(e)).toList(),
    );
  }

  Future<void> clearSearchHistory() async {
    final box = await _openHistoryBox();

    await box.delete(_searchHistoryKey);

    searchHistoryList.clear();
  }

  // Future<void> getSearchResult(SearchRequest request) async {
  //   try {
  //     isLoading.value = true;

  //     final result = await getSearchResultUseCase(request);

  //     result.fold(
  //       (failure) {
  //         Get.snackbar('Error', failure.message);
  //       },
  //       (response) {
  //         searchResultList.value = response.data;
  //       },
  //     );
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  void clearResults() {
    ramroResultList.clear();
    googleResultList.clear();
  }
}
