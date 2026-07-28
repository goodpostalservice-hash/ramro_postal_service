import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramro_postal_service/features/home/presentation/controllers/home_controller.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/add_location_request.dart';
import '../../domain/usecases/add_missing_place_usecase.dart';
import '../../data/models/saved_address_response.dart';
import '../../domain/usecases/getSavedAddress_usecase.dart';
import '../../domain/usecases/save_address_usecase.dart';
import '../../data/models/save_address_request.dart';
import '../../domain/usecases/delete_saved_address_usecase.dart';
import '../../../home/domain/usecases/get_map_data_usecase.dart';
import '../../../home/presentation/controllers/house_marker_controller.dart';

class AddressController extends GetxController {
  // USECASE_FIELDS_START

  final GetsavedaddressUseCase getsavedaddressUseCase;
  final SaveAddressUseCase saveAddressUseCase;
  final AddMissingPlaceUseCase addMissingPlaceUseCase;
  final DeleteSavedAddressUseCase deleteSavedAddressUseCase;
  final GetMapDataUseCase getMapDataUseCase;
  // USECASE_FIELDS_END

  AddressController({
    // USECASE_CONSTRUCTOR_START
    required this.getsavedaddressUseCase,
    required this.saveAddressUseCase,
    required this.addMissingPlaceUseCase,
    required this.deleteSavedAddressUseCase,
    required this.getMapDataUseCase,
    // USECASE_CONSTRUCTOR_END
  }) {
    _houseMarkerController = HouseMarkerController(
      getMapDataUseCase: getMapDataUseCase,
      currentZoom: currentZoom,
    );
  }

  final isLoading = false.obs;
  final isSaving = false.obs;
  final resultList = <Addresses>[].obs;
  final addingPlace = false.obs;
  final isDeleting = false.obs;

  final LatLng initialPosition = // Initial map position;
      Get.find<HomeController>().myCurrentLocation.value;
  final currentZoom = 20.0.obs;
  late final HouseMarkerController _houseMarkerController;

  GoogleMapController? get mapController =>
      _houseMarkerController.mapController;
  Set<Marker> get houseMarkers => _houseMarkerController.markers;

  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final zipCodeController = TextEditingController();
  final areaController = TextEditingController();
  final zoneController = TextEditingController();
  final subZoneController = TextEditingController();
  final streetController = TextEditingController();
  final houseNumberController = TextEditingController();
  final noteController = TextEditingController();

  final isToLoadMore = false.obs;
  final selectedIndex = 0.obs;
  final selectedValue = ''.obs;

  void onMapCreated(GoogleMapController controller) {
    _houseMarkerController.onMapCreated(controller);
  }

  void onCameraMove(CameraPosition position) {
    _houseMarkerController.onCameraMove(position);
    latitudeController.text = position.target.latitude.toString();
    longitudeController.text = position.target.longitude.toString();
  }

  void onCameraIdle() {
    _houseMarkerController.onCameraIdle();
  }

  LatLng? parseCoordinates(String? coordinates) {
    if (coordinates == null) return null;

    final parts = coordinates.split(',');
    if (parts.length != 2) return null;

    final latitude = double.tryParse(parts[0].trim());
    final longitude = double.tryParse(parts[1].trim());
    if (latitude == null || longitude == null) return null;
    if (latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      return null;
    }

    return LatLng(latitude, longitude);
  }

  @override
  void onClose() {
    _houseMarkerController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    zipCodeController.dispose();
    areaController.dispose();
    zoneController.dispose();
    subZoneController.dispose();
    streetController.dispose();
    noteController.dispose();
    houseNumberController.dispose();
    super.onClose();
  }

  // API_METHODS_START
  // API_METHODS_END
  Future<void> getsavedaddress() async {
    try {
      isLoading.value = true;

      final result = await getsavedaddressUseCase(const NoParams());

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) {
          resultList.clear();
          resultList.assignAll(response.addresses ?? []);
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveAddress(SaveAddressRequest request) async {
    try {
      isSaving.value = true;

      final result = await saveAddressUseCase(request);

      return result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
          return false;
        },
        (response) {
          getsavedaddress();
          return response.success!;
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> addMissingPlace(AddLocationRequest request) async {
    try {
      addingPlace.value = true;

      final result = await addMissingPlaceUseCase(request);

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) {
          Get.snackbar(
            'Success',
            response.message ?? 'Request completed successfully',
          );
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      addingPlace.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    latitudeController.text = initialPosition.latitude.toString();
    longitudeController.text = initialPosition.longitude.toString();
    getsavedaddress();
  }

  Future<void> deleteSavedAddress(int id, BuildContext ctx) async {
    try {
      isDeleting.value = true;

      final result = await deleteSavedAddressUseCase(id);

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) async {
          if (response.success == true) {
            Get.snackbar('Success', response.message);
            Navigator.of(ctx).pop();
            // Close the dialog after deletion
            await getsavedaddress();
          } else {
            Get.snackbar('Error', response.message);
          }
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isDeleting.value = false;
    }
  }
}
