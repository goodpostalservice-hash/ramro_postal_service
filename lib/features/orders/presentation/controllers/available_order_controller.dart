import 'package:get/get.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_available_orders_usecase.dart';

class AvailableOrderController extends GetxController {
  // USECASE_FIELDS_START
  final GetAvailableOrdersUseCase getAvailableOrdersUseCase;
  // USECASE_FIELDS_END

  AvailableOrderController({
    // USECASE_CONSTRUCTOR_START
    required this.getAvailableOrdersUseCase,
    // USECASE_CONSTRUCTOR_END
  });

  final isLoading = false.obs;

  // API_METHODS_START
  // API_METHODS_END
  Future<void> getAvailableOrders() async {
    try {
      isLoading.value = true;

      final result = await getAvailableOrdersUseCase(const NoParams());

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) {
          Get.snackbar('Success', 'Request completed successfully');
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getAvailableOrders();
  }
}
