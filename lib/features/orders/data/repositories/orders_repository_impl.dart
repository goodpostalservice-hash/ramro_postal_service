import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/available_order_response.dart';
import '../models/order_history_response.dart';
import '../models/order_details_response.dart';
import '../models/update_order_request.dart';
import '../models/update_order_response.dart';
import '../models/accept_order_request.dart';
import '../models/accept_order_response.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;
  const OrdersRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, AvailableOrderResponse>> getAvailableOrders() async {
    try {
      final result = await remoteDataSource.getAvailableOrders();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, OrderHistoryResponse>> getOrderHistory() async {
    try {
      final result = await remoteDataSource.getOrderHistory();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, OrderDetailsResponse>> getOrderDetails() async {
    try {
      final result = await remoteDataSource.getOrderDetails();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, UpdateOrderResponse>> updateOrderStatus(UpdateOrderRequest request) async {
    try {
      final result = await remoteDataSource.updateOrderStatus(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, AcceptOrderResponse>> acceptOrder(AcceptOrderRequest request) async {
    try {
      final result = await remoteDataSource.acceptOrder(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


}
