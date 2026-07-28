import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/update_order_request.dart';
import '../../data/models/update_order_response.dart';
import '../repositories/orders_repository.dart';

class UpdateOrderStatusUseCase extends UseCase<UpdateOrderResponse, UpdateOrderRequest> {
  final OrdersRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  @override
  Future<Either<Failure, UpdateOrderResponse>> call(UpdateOrderRequest request) {
    return repository.updateOrderStatus(request);
  }
}
