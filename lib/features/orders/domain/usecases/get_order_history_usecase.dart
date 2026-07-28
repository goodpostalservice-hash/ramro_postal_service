import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/order_history_response.dart';
import '../repositories/orders_repository.dart';

class GetOrderHistoryUseCase extends UseCase<OrderHistoryResponse, NoParams> {
  final OrdersRepository repository;

  GetOrderHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, OrderHistoryResponse>> call(NoParams params) {
    return repository.getOrderHistory();
  }
}
