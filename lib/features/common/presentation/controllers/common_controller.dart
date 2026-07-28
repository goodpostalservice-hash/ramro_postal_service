import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/address_split.dart';
import '../../../home/presentation/controllers/home_controller.dart';
import '../../../home/presentation/widgets/get_location_name.dart';
import '../../data/models/location_data_response.dart';
import '../../domain/usecases/get_location_name_usecase.dart';
import '../../data/models/location_name_request.dart';

class CommonController extends GetxController {
  // USECASE_FIELDS_START

  final GetLocationNameUseCase getLocationNameUseCase;

  // USECASE_FIELDS_END

  CommonController({
    // USECASE_CONSTRUCTOR_START
    required this.getLocationNameUseCase,

    // USECASE_CONSTRUCTOR_END
  });

  final isGettingLocation = false.obs;

  final RxBool notifEnabled = false.obs;
  final RxBool locationEnabled = true.obs;
  final isButtonVisible = true.obs;
  final driverController = Get.find<HomeController>();

  // API_METHODS_START
  // API_METHODS_END
  Future<LocationDataResponse?> getLocationName(
    LocationNameRequest request,
  ) async {
    try {
      isGettingLocation.value = true;

      final result = await getLocationNameUseCase(request);

      return await result.fold(
        (failure) async {
          Get.snackbar('Error', failure.message);
          return null;
        },
        (response) async {
          if (response.success == true && response.data != null) {
            final fullAddress = response.data?.fullAddressDetail;
            final locationName = response.data?.locationName;

            driverController.myDestinationName.value =
                fullAddress != null && fullAddress.isNotEmpty
                ? splitCoordinateString(fullAddress)
                : locationName ?? "Unknown Address";
            driverController.selectedHouseSubtitle.value =
                "${response.data?.zone} ,${response.data?.subZone}";

            return response;
          }

          final lat = double.tryParse(request.latitude);
          final lng = double.tryParse(request.longitude);

          if (lat == null || lng == null) {
            driverController.myDestinationName.value = "Unknown Address";
            return response;
          }

          final googleAddress = await getGoogleLocationName(lat, lng);

          driverController.myDestinationName.value = googleAddress;

          return response;
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return null;
    } finally {
      isGettingLocation.value = false;
    }
  }
}
