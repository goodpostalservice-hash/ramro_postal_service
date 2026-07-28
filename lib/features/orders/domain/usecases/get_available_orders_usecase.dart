import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/available_order_response.dart';
import '../repositories/orders_repository.dart';

class GetAvailableOrdersUseCase extends UseCase<AvailableOrderResponse, NoParams> {
  final OrdersRepository repository;

  GetAvailableOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, AvailableOrderResponse>> call(NoParams params) {
    return repository.getAvailableOrders();
  }
}
