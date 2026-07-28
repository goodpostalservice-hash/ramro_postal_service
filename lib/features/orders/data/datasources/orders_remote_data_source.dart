import 'package:ramro_postal_service/core/constants/app_exports.dart';
import 'package:ramro_postal_service/core/storage/storage_util.dart';

import '../../../../core/network/api_client.dart';
import '../models/available_order_response.dart';
import '../models/order_history_response.dart';
import '../models/order_details_response.dart';
import '../models/update_order_request.dart';
import '../models/update_order_response.dart';
import '../models/accept_order_request.dart';
import '../models/accept_order_response.dart';

abstract class OrdersRemoteDataSource {
  Future<AvailableOrderResponse> getAvailableOrders();
  Future<OrderHistoryResponse> getOrderHistory();
  Future<OrderDetailsResponse> getOrderDetails();
  Future<UpdateOrderResponse> updateOrderStatus(UpdateOrderRequest request);
  Future<AcceptOrderResponse> acceptOrder(AcceptOrderRequest request);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final ApiClient apiClient;
  const OrdersRemoteDataSourceImpl({required this.apiClient});
  @override
  Future<AvailableOrderResponse> getAvailableOrders() async {
    final response = await apiClient.get(
      ApiConstant.availableOrder,
      needToken: true,
    );

    return AvailableOrderResponse.fromJson(response.data);
  }

  @override
  Future<OrderHistoryResponse> getOrderHistory() async {
    final response = await apiClient.get(
      SStorageUtil.getUserData()!.userType == 'user'
          ? ApiConstant.orderHistory
          : ApiConstant.driverOrderHistory,
      needToken: true,
    );

    return OrderHistoryResponse.fromJson(response.data);
  }

  @override
  Future<OrderDetailsResponse> getOrderDetails() async {
    final response = await apiClient.get(
      ApiConstant.orderDetail(1),
      needToken: true,
    );

    return OrderDetailsResponse.fromJson(response.data);
  }

  @override
  Future<UpdateOrderResponse> updateOrderStatus(
    UpdateOrderRequest request,
  ) async {
    final response = await apiClient.post(
      ApiConstant.updateOrderStatus,
      data: request.toJson(),
      needToken: true,
    );

    return UpdateOrderResponse.fromJson(response.data);
  }

  @override
  Future<AcceptOrderResponse> acceptOrder(AcceptOrderRequest request) async {
    final response = await apiClient.post(
      ApiConstant.acceptOrder,
      data: request.toJson(),
      needToken: true,
    );

    return AcceptOrderResponse.fromJson(response.data);
  }
}
