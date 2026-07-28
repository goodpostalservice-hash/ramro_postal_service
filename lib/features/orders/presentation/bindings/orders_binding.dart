import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/orders_remote_data_source.dart';
import '../../data/repositories/orders_repository_impl.dart';
import '../../domain/repositories/orders_repository.dart';
import '../controllers/orders_controller.dart';
import '../../domain/usecases/get_available_orders_usecase.dart';
import '../../domain/usecases/get_order_history_usecase.dart';
import '../../domain/usecases/get_order_details_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';
import '../../domain/usecases/accept_order_usecase.dart';
import '../controllers/order_history_controller.dart';
import '../controllers/available_order_controller.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersRemoteDataSource>(
      () => OrdersRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<OrdersRepository>(
      () => OrdersRepositoryImpl(
        remoteDataSource: Get.find<OrdersRemoteDataSource>(),
      ),
      fenix: true,
    );

    // USECASE_INJECTIONS_START
    Get.lazyPut<GetAvailableOrdersUseCase>(
      () => GetAvailableOrdersUseCase(Get.find<OrdersRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetOrderHistoryUseCase>(
      () => GetOrderHistoryUseCase(Get.find<OrdersRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetOrderDetailsUseCase>(
      () => GetOrderDetailsUseCase(Get.find<OrdersRepository>()),
      fenix: true,
    );

    Get.lazyPut<UpdateOrderStatusUseCase>(
      () => UpdateOrderStatusUseCase(Get.find<OrdersRepository>()),
      fenix: true,
    );

    Get.lazyPut<AcceptOrderUseCase>(
      () => AcceptOrderUseCase(Get.find<OrdersRepository>()),
      fenix: true,
    );

    // USECASE_INJECTIONS_END

    Get.lazyPut<OrdersController>(
      () => OrdersController(
        // CONTROLLER_USECASES_START
        getOrderDetailsUseCase: Get.find<GetOrderDetailsUseCase>(),
        updateOrderStatusUseCase: Get.find<UpdateOrderStatusUseCase>(),
        acceptOrderUseCase: Get.find<AcceptOrderUseCase>(),
        // CONTROLLER_USECASES_END
      ),
    );
    Get.lazyPut<OrderHistoryController>(
      () => OrderHistoryController(
        // OrderHistoryController_USECASES_START
        getOrderHistoryUseCase: Get.find<GetOrderHistoryUseCase>(),
        // OrderHistoryController_USECASES_END
      ),
    );
    Get.lazyPut<AvailableOrderController>(
      () => AvailableOrderController(
        // AvailableOrderController_USECASES_START
        getAvailableOrdersUseCase: Get.find<GetAvailableOrdersUseCase>(),
        // AvailableOrderController_USECASES_END
      ),
    );
  }
}
