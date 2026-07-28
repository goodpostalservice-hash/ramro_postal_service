import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/available_order_response.dart';
import '../../data/models/order_history_response.dart';
import '../../data/models/order_details_response.dart';
import '../../data/models/update_order_request.dart';
import '../../data/models/update_order_response.dart';
import '../../data/models/accept_order_request.dart';
import '../../data/models/accept_order_response.dart';
abstract class OrdersRepository {
  Future<Either<Failure, AvailableOrderResponse>> getAvailableOrders();

  Future<Either<Failure, OrderHistoryResponse>> getOrderHistory();

  Future<Either<Failure, OrderDetailsResponse>> getOrderDetails();

  Future<Either<Failure, UpdateOrderResponse>> updateOrderStatus(UpdateOrderRequest request);

  Future<Either<Failure, AcceptOrderResponse>> acceptOrder(AcceptOrderRequest request);

}
