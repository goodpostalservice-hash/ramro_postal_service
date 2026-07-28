import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/order_details_response.dart';
import '../repositories/orders_repository.dart';

class GetOrderDetailsUseCase extends UseCase<OrderDetailsResponse, NoParams> {
  final OrdersRepository repository;

  GetOrderDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, OrderDetailsResponse>> call(NoParams params) {
    return repository.getOrderDetails();
  }
}
