import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';

import '../../data/models/add_location_request.dart';
import '../controllers/address_controller.dart';

class AddPlaceScreen extends GetView<AddressController> {
  static double? lat, lng;
  static const double _markerWidth = 40.0;
  static const double _markerHeight = AppSizes.mapMarkerLg + AppSpacing.md;
  static const double _markerCenterYOffset = 220.0;

  final formKey = GlobalKey<FormState>();

  AddPlaceScreen({super.key});

  Color get _border => appTheme.grayScale300;
  Color get _grabber => appTheme.gray200;

  Future<void> _onCameraIdle({
    required double markerTipX,
    required double markerTipY,
  }) async {
    // Keep the existing house-marker loading/debounce behavior.
    controller.onCameraIdle();

    final mapController = controller.mapController;
    if (mapController == null) return;

    final pinnedLocation = await mapController.getLatLng(
      ScreenCoordinate(x: markerTipX.round(), y: markerTipY.round()),
    );

    lat = pinnedLocation.latitude;
    lng = pinnedLocation.longitude;
    controller.latitudeController.text = pinnedLocation.latitude.toString();
    controller.longitudeController.text = pinnedLocation.longitude.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white,

      // Keep your custom app bar if you have one; otherwise this matches the mock
      appBar: AppBar(
        backgroundColor: appTheme.white,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(Icons.arrow_back, color: appTheme.black),
        ),
        title: Text(
          'Add missing place',
          style: CustomTextStyles.titleMediumBlack18_500.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),

      body: Stack(
        children: [
          // MAP BEHIND
          Positioned.fill(
            child: Obx(
              () => GoogleMap(
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                onMapCreated: controller.onMapCreated,
                markers: {...controller.houseMarkers},
                onCameraMove: (position) {
                  controller.onCameraMove(position);
                },
                onCameraIdle: () {
                  final screenSize = MediaQuery.sizeOf(context);
                  final markerTop =
                      screenSize.height / 2 - _markerCenterYOffset;
                  _onCameraIdle(
                    markerTipX: screenSize.width / 2,
                    markerTipY: markerTop + _markerHeight,
                  );
                },
                initialCameraPosition: CameraPosition(
                  target: controller.initialPosition,
                  zoom: 20,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height / 2 - _markerCenterYOffset,
            left: MediaQuery.sizeOf(context).width / 2 - (_markerWidth / 2),
            child: Image.asset(
              AppAssets.iconsIcMarkerRidesDestination,
              width: _markerWidth,
              height: _markerHeight,
              fit: BoxFit.contain,
            ),
          ),

          // DRAGGABLE BOTTOM SHEET
          DraggableScrollableSheet(
            initialChildSize: 0.62, // ~top of form like the mock
            minChildSize: 0.55,
            maxChildSize: 0.95,
            builder: (context, scrollCtrl) {
              return Material(
                color: appTheme.white,
                elevation: 12,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.bottomSheet),
                  topRight: Radius.circular(AppRadius.bottomSheet),
                ),
                child: Form(
                  key: formKey,
                  child: ListView(
                    controller: scrollCtrl,
                    padding: AppSpacing.only(
                      left: AppSpacing.screenHorizontal,
                      right: AppSpacing.screenHorizontal,
                      bottom: AppSpacing.xxl,
                    ),
                    children: [
                      AppSpacing.gapSm,
                      // grabber
                      Center(
                        child: Container(
                          width: AppSpacing.hyper,
                          height: AppSpacing.xs,
                          decoration: BoxDecoration(
                            color: _grabber,
                            borderRadius: AppRadius.circular(AppRadius.xs),
                          ),
                        ),
                      ),
                      AppSpacing.gapLg,

                      // Place name
                      const _FieldLabel('Latitude'),
                      CustomTextFormField(
                        controller: controller.latitudeController,
                        hint: 'Enter latitude',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const _FieldLabel('Longitude'),
                      CustomTextFormField(
                        controller: controller.longitudeController,
                        hint: 'Enter longitude',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const _FieldLabel('Zip Code'),
                      CustomTextFormField(
                        controller: controller.zipCodeController,
                        hint: 'Enter zip code',
                      ),
                      const _FieldLabel('Area'),
                      CustomTextFormField(
                        controller: controller.areaController,
                        hint: 'Enter area',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const _FieldLabel('Zone'),
                      CustomTextFormField(
                        controller: controller.zoneController,
                        hint: 'Enter zone',
                      ),
                      const _FieldLabel('Sub Zone'),
                      CustomTextFormField(
                        controller: controller.subZoneController,
                        hint: 'Enter sub zone',
                      ),
                      const _FieldLabel('Street'),
                      CustomTextFormField(
                        controller: controller.streetController,
                        hint: 'Enter street name',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const _FieldLabel('House Number'),
                      CustomTextFormField(
                        controller: controller.houseNumberController,
                        hint: 'Enter house number',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),

                      // Address
                      const _FieldLabel('Note'),
                      CustomTextFormField(
                        controller: controller.noteController,
                        hint: 'Enter note',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),

                      AppSpacing.gapLg,

                      // Info note
                      _InfoNote(),

                      AppSpacing.gapMd,
                      Divider(color: _border, height: 1),

                      AppSpacing.gapLg,

                      Obx(
                        () => AppButton(
                          label: 'Update Address',
                          loadingText: 'Please wait…',
                          isLoading: controller.addingPlace.value,
                          onPressed: controller.addingPlace.value
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }

                                  final request = AddLocationRequest(
                                    latitude:
                                        controller.latitudeController.text,
                                    longitude:
                                        controller.longitudeController.text,
                                    cordinate:
                                        "${AddPlaceScreen.lat ?? controller.initialPosition.latitude} ${AddPlaceScreen.lng ?? controller.initialPosition.longitude}",
                                    zipCode: controller.zipCodeController.text,
                                    area: controller.areaController.text,
                                    zone: controller.zoneController.text,
                                    subZone: controller.subZoneController.text,
                                    street: controller.streetController.text,
                                    houseNumber:
                                        controller.houseNumberController.text,
                                    locationName:
                                        controller.noteController.text,
                                  );
                                  await controller.addMissingPlace(request);
                                },
                        ),
                      ),

                      AppSpacing.gapSm,
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
      padding: AppSpacing.symmetric(vertical: AppSpacing.xs + AppSpacing.xxs),
      child: Text(
        text,
        style: CustomTextStyles.bodyMediumBlack14_400.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final grey = appTheme.gray700;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Ramro postal service ',
            style: CustomTextStyles.bodyMediumBlack14_400.copyWith(
              fontWeight: FontWeight.w600,
            ),
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
