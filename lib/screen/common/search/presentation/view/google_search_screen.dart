import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:ramro_postal_service/screen/common/profile/controller/profile_controller.dart';
import 'package:ramro_postal_service/screen/common/search/controller/search_controller.dart';
import 'package:ramro_postal_service/screen/common/search/model/search_model_response.dart';
import 'package:ramro_postal_service/screen/common/search/presentation/view/show_search_on_map_screen.dart';

class GoogleSearchScreen extends StatefulWidget {
  const GoogleSearchScreen({super.key, this.pickLocation});
  final int? pickLocation;

  @override
  State<GoogleSearchScreen> createState() => _GoogleSearchScreenState();
}

class _GoogleSearchScreenState extends State<GoogleSearchScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();

  late final SearchMapController searchResultController;
  late final ProfileController profileController;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    searchResultController = Get.put(SearchMapController());
    profileController = Get.put(ProfileController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final query = value.trim();

      if (query.isEmpty) {
        searchResultController.clearResults();
        return;
      }

      await searchResultController.getSearchAddresses(query);
    });
  }

  void _onTapResult(SearchAddress item) {
    final longitude = item.longitude ?? '';
    final latitude = item.latitude ?? '';
    final address = item.fullAddressDetail ?? _buildAddress(item);
    final houseNo = item.houseNum ?? '';
    final street = item.street ?? '';
    final zone = item.zone ?? '';
    final subZone = item.subZone ?? '';
    final coordinate = item.cordinate ?? '';
    final zipCode = item.zipCode ?? '';
    final area = item.area ?? '';

    final myList = [
      longitude,
      latitude,
      coordinate,
      zipCode,
      area,
      zone,
      subZone,
      street,
      houseNo,
      address,
    ];

    if (widget.pickLocation == 0) {
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.pop(context, myList);
    } else if (widget.pickLocation == 1) {
      Navigator.pop(context, myList);
    } else if (widget.pickLocation == 2) {
      profileController.addressController.text = address;
      Navigator.pop(context, myList);
    } else {
      Get.to(
        () => ShowSearchOnMapScreen(
          longitude: double.tryParse(longitude) ?? 0.0,
          latitude: double.tryParse(latitude) ?? 0.0,
          address: address,
          houseno: houseNo,
          street: street,
          zone: zone,
          sub: subZone,
        ),
      );
    }
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
              controller: searchController,
              focusNode: _focusNode,
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: Obx(() {
              final isLoading = searchResultController.isLoading.value;
              final results = searchResultController.searchResultList;
              final hasQuery = searchController.text.trim().isNotEmpty;

              if (!hasQuery) {
                return const Center(
                  child: Text(
                    'Search address',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                );
              }

              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (results.isEmpty) {
                return const Center(
                  child: Text(
                    'No data found',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                );
              }

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: results.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey.shade300),
                itemBuilder: (context, index) {
                  final item = results[index];
                  final address = _buildAddress(item);

                  return InkWell(
                    onTap: () => _onTapResult(item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.location_on_outlined,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              address,
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
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
