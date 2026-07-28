import 'package:get/get.dart';
import 'package:ramro_postal_service/features/orders/data/models/order_details_response.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/order_history_response.dart';
import '../../domain/usecases/get_order_details_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';
import '../../data/models/update_order_request.dart';
import '../../domain/usecases/accept_order_usecase.dart';
import '../../data/models/accept_order_request.dart';

class OrdersController extends GetxController {
  // USECASE_FIELDS_START

  final GetOrderDetailsUseCase getOrderDetailsUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;
  final AcceptOrderUseCase acceptOrderUseCase;
  // USECASE_FIELDS_END

  OrdersController({
    // USECASE_CONSTRUCTOR_START
    required this.getOrderDetailsUseCase,
    required this.updateOrderStatusUseCase,
    required this.acceptOrderUseCase,
    // USECASE_CONSTRUCTOR_END
  });

  final isLoading = false.obs;
  final orderDetailsResult = OrderDetailsResponse().obs;
  final modelValue = OrderHistoryResponse().obs;
  List<Orders> get orders => modelValue.value.orders ?? [];

  // API_METHODS_START
  // API_METHODS_END

  Future<void> getOrderDetails() async {
    try {
      isLoading.value = true;

      final result = await getOrderDetailsUseCase(const NoParams());

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) {
          orderDetailsResult.value = response;
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOrderStatus(UpdateOrderRequest request) async {
    try {
      isLoading.value = true;

      final result = await updateOrderStatusUseCase(request);

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

  Future<void> acceptOrder(AcceptOrderRequest request) async {
    try {
      isLoading.value = true;

      final result = await acceptOrderUseCase(request);

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
  }
}
