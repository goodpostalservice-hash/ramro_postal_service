import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/accept_order_request.dart';
import '../../data/models/accept_order_response.dart';
import '../repositories/orders_repository.dart';

class AcceptOrderUseCase extends UseCase<AcceptOrderResponse, AcceptOrderRequest> {
  final OrdersRepository repository;

  AcceptOrderUseCase(this.repository);

  @override
  Future<Either<Failure, AcceptOrderResponse>> call(AcceptOrderRequest request) {
    return repository.acceptOrder(request);
  }
}
