import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';

import '../../../../user/widget/place_list.dart';
import '../../controller/add_place_controller.dart';

class AddPlaceScreen extends GetView<AddPlaceController> {
  static double? lat, lng;
  final formKey = GlobalKey<FormState>();

  AddPlaceScreen({super.key});

  Color get _border => const Color(0xFFE6E6E6);
  Color get _grabber => const Color(0xFFEDEDED);
  Color get _orange => const Color(0xFFFF910D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Keep your custom app bar if you have one; otherwise this matches the mock
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(Icons.arrow_back, color: AppColors.blackBold),
        ),
        title: const Text(
          'Add missing place',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
        ),
        centerTitle: false,
      ),

      body: Stack(
        children: [
          // MAP BEHIND
          Positioned.fill(
            child: GoogleMap(
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              onMapCreated: controller.onMapCreated,
              initialCameraPosition: CameraPosition(
                target: controller.initialPosition,
                zoom: 16.5,
              ),
            ),
          ),

          // DRAGGABLE BOTTOM SHEET
          DraggableScrollableSheet(
            initialChildSize: 0.62, // ~top of form like the mock
            minChildSize: 0.55,
            maxChildSize: 0.95,
            builder: (context, scrollCtrl) {
              return Material(
                color: Colors.white,
                elevation: 12,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
                child: Form(
                  key: formKey,
                  child: ListView(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 24,
                    ),
                    children: [
                      const SizedBox(height: 8),
                      // grabber
                      Center(
                        child: Container(
                          width: 56,
                          height: 5,
                          decoration: BoxDecoration(
                            color: _grabber,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Place name
                      const _FieldLabel('Place name'),
                      CustomTextFormField(
                        controller: controller.placeNameController,
                        hint: 'Enter place name',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),

                      // Address
                      const _FieldLabel('Address'),
                      CustomTextFormField(
                        controller: controller.addressController,
                        hint: 'Enter address',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),

                      // House number
                      const _FieldLabel('House number'),
                      CustomTextFormField(
                        controller: controller.houseNumberController,
                        hint: 'Enter house number',
                      ),

                      // Listing type (dropdown)
                      const _FieldLabel('Listing type'),
                      _OutlinedDropdown(
                        valueRx: controller.selectedItem,
                        items: PlaceList.allList,
                        border: _border,
                      ),

                      const SizedBox(height: 16),

                      // Info note
                      _InfoNote(),

                      const SizedBox(height: 12),
                      Divider(color: _border, height: 1),

                      const SizedBox(height: 16),

                      Obx(
                        () => AppButton(
                          label: 'Update Address',
                          loadingText: 'Please wait…',
                          isLoading: controller.isToLoadMore.value,
                          onPressed: controller.isToLoadMore.value
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }
                                  controller.isToLoadMore.value = true;

                                  // Make sure lat/lng not null
                                  final latStr =
                                      (AddPlaceScreen.lat ??
                                              controller
                                                  .initialPosition
                                                  .latitude)
                                          .toString();
                                  final lngStr =
                                      (AddPlaceScreen.lng ??
                                              controller
                                                  .initialPosition
                                                  .longitude)
                                          .toString();

                                  await controller.addMissingPlace(
                                    latStr,
                                    lngStr,
                                    controller.placeNameController.text,
                                    controller.houseNumberController.text,
                                    controller.selectedItem.value,
                                  );

                                  controller.isToLoadMore.value = false;
                                },
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/* ----------------- Small helpers to match the mock ----------------- */

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.black87,
          fontSize: 13.5,
        ),
      ),
    );
  }
}

class _OutlinedDropdown extends StatelessWidget {
  const _OutlinedDropdown({
    required this.valueRx,
    required this.items,
    required this.border,
  });

  final RxString valueRx;
  final List<String> items;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: border, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: valueRx.value,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            onChanged: (v) {
              if (v != null) valueRx.value = v;
            },
            items: items
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(
                      e,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final grey = const Color(0xFF6C6C6C);
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: 'Ramro postal service ',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text:
                'will email you or directly contact you about the status edits. Please wait as review takes 8–10 business days',
            style: TextStyle(color: grey, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      textAlign: TextAlign.left,
    );
  }
}
