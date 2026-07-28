import 'package:get/get.dart';

import '../../../../core/usecases/usecase.dart';
import '../../data/models/available_package.dart';
import '../../domain/usecases/get_pacakge_usecase.dart';

class PackageController extends GetxController {
  // USECASE_FIELDS_START
  final GetPacakgeUseCase getPacakgeUseCase;
  // USECASE_FIELDS_END

  PackageController({
    // USECASE_CONSTRUCTOR_START
    required this.getPacakgeUseCase,
    // USECASE_CONSTRUCTOR_END
  });

  final isLoading = false.obs;
  List<AvailablePackageModel> availablePackages = <AvailablePackageModel>[].obs;

  // API_METHODS_START
  // API_METHODS_END
  Future<void> getPackages() async {
    try {
      isLoading.value = true;

      final result = await getPacakgeUseCase(const NoParams());

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) {
          availablePackages.assignAll(response);
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  onInit() {
    super.onInit();
    getPackages();
  }
}
