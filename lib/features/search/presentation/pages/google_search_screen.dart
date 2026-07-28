import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/address_split.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';
import '../../../home/presentation/widgets/search_bar.dart';
import '../../data/models/search_response.dart';
import '../bindings/show_search_on_map_binding.dart';
import '../controllers/search_controller.dart';
import 'show_search_on_map_screen.dart';

class GoogleSearchScreen extends StatefulWidget {
  const GoogleSearchScreen({super.key, this.pickAddress});
  final bool? pickAddress;

  @override
  State<GoogleSearchScreen> createState() => _GoogleSearchScreenState();
}

class _GoogleSearchScreenState extends State<GoogleSearchScreen> {
  final FocusNode _focusNode = FocusNode();

  late final SearchAddressController searchResultController;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    searchResultController = Get.find<SearchAddressController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTapResult(SearchAddress item) async {
    if ((item.latitude == null || item.latitude!.isEmpty) &&
        item.placeId != null) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final details = await searchResultController.getGooglePlaceDetails(
        item.placeId!,
      );

      Get.back();

      if (details != null) {
        item = SearchAddress(
          id: item.id,
          fullAddressDetail:
              details.fullAddressDetail ?? item.fullAddressDetail,
          latitude: details.latitude,
          longitude: details.longitude,
          placeId: item.placeId,
          source: item.source,
        );
      } else {
        Get.snackbar('Error', 'Could not get coordinates for this address.');
        return;
      }
    }

    if (!item.hasCoordinates) {
      Get.snackbar('Error', 'This address does not have valid coordinates.');
      return;
    }

    final longitude = item.longitude!;
    final latitude = item.latitude!;
    final address = item.fullAddressDetail ?? _buildAddress(item);
    final houseNo = item.houseNum ?? '';
    final street = item.street ?? '';
    final zone = item.zone ?? '';
    final subZone = item.subZone ?? '';
    final locationName = item.locationName ?? '';

    if (widget.pickAddress == true) {
      Get.back(result: item);
      return;
    }

    Get.to(
      () => ShowSearchOnMapScreen(
        longitude: double.tryParse(longitude) ?? 0.0,
        latitude: double.tryParse(latitude) ?? 0.0,
        address: address,
        houseno: houseNo,
        street: street,
        zone: zone,
        sub: subZone,
        locationName: locationName,
      ),
      binding: ShowSearchOnMapBinding(),
    );
  }

  void onSearchChanged(String value) {
    searchResultController.onSearchChanged(value);
  }

  String _buildAddress(SearchAddress item) {
    if ((item.fullAddressDetail ?? '').trim().isNotEmpty) {
      return item.fullAddressDetail!.trim();
    }

    final parts =
        [
              item.houseNum,
              item.street,
              item.subZone,
              item.zone,
              item.area,
              item.zipCode,
            ]
            .where((e) => e != null && e.toString().trim().isNotEmpty)
            .map((e) => e.toString().trim())
            .toList();

    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white,
      appBar: AppBar(
        backgroundColor: appTheme.white,
        elevation: 0,
        foregroundColor: appTheme.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SearchPanel(
              controller: searchResultController.searchController,
              focusNode: _focusNode,
              onChanged: searchResultController.onSearchChanged,
            ),
          ),
          Expanded(
            child: Obx(() {
              final isLoading = searchResultController.isLoading.value;

              final ramroResults = searchResultController.ramroResultList;
              final googleResults = searchResultController.googleResultList;

              final history = searchResultController.searchHistoryList;
              final hasQuery = searchResultController.searchController.text
                  .trim()
                  .isNotEmpty;

              if (!hasQuery) {
                if (history.isEmpty) {
                  return const Center(
                    child: Text(
                      'Search address',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: getPadding(top: 12),
                  children: [
                    Padding(
                      padding: getPadding(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Recent Searches",
                            style: CustomTextStyles.titleMediumBlack18_500,
                          ),
                          GestureDetector(
                            onTap: searchResultController.clearSearchHistory,
                            child: Text(
                              "Clear",
                              style: CustomTextStyles.bodySmallGray800_12_400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...history.map(
                      (item) => ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(
                          item.fullAddressDetail ?? item.locationName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          searchResultController.searchController.text =
                              item.fullAddressDetail ?? item.locationName ?? '';
                          _onTapResult(item);
                        },
                      ),
                    ),
                  ],
                );
              }

              if (isLoading && ramroResults.isEmpty && googleResults.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final combinedResults = searchResultController
                  .getCombinedSortedResults();

              if (combinedResults.isEmpty) {
                return const Center(
                  child: Text(
                    'No data found',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                );
              }

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 12),
                itemCount: combinedResults.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey.shade300),
                itemBuilder: (context, index) {
                  return _buildAddressTile(combinedResults[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Individual Address Tile
  Widget _buildAddressTile(SearchAddress item) {
    final isRamro = item.isRamro;

    final address = _buildAddress(item);
    final displayAddress = isRamro
        ? splitCoordinateString(address)
        : (item.fullAddressDetail ?? address);

    return InkWell(
      onTap: () async {
        await searchResultController.saveSearchHistory(item);
        _onTapResult(item);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isRamro
                    ? const Color(0xFFFFF3E8)
                    : const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isRamro ? Icons.home_work_outlined : Icons.location_on_outlined,
                color: isRamro ? Colors.orange : Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                displayAddress,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
