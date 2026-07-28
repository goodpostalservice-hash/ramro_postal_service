import 'dart:async';

import 'package:get/get.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/order_history_response.dart';
import '../../domain/usecases/get_order_history_usecase.dart';

class OrderHistoryController extends GetxController {
  // USECASE_FIELDS_START
  final GetOrderHistoryUseCase getOrderHistoryUseCase;
  // USECASE_FIELDS_END

  OrderHistoryController({
    // USECASE_CONSTRUCTOR_START
    required this.getOrderHistoryUseCase,
    // USECASE_CONSTRUCTOR_END
  });

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final modelValue = OrderHistoryResponse().obs;
  List<Orders> get orders => modelValue.value.orders ?? [];

  // API_METHODS_START
  // API_METHODS_END
  Future<void> getOrderHistory() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final result = await getOrderHistoryUseCase(
        const NoParams(),
      ).timeout(const Duration(seconds: 12));

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          Get.snackbar('Error', failure.message);
        },
        (response) {
          modelValue.value = response;
        },
      );
    } on TimeoutException {
      modelValue.value = OrderHistoryResponse(orders: []);
    } catch (e) {
      final message = e.toString();
      errorMessage.value = message;
      Get.snackbar('Error', message);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getOrderHistory();
  }
}
