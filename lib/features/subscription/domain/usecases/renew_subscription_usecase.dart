import 'package:dartz/dartz.dart';
import 'package:ramro_postal_service/features/common/data/models/success_respone.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/subscribe_request.dart';
import '../repositories/subscription_repository.dart';

class RenewSubscriptionUseCase
    extends UseCase<SuccessResponse, SubscribeRequest> {
  final SubscriptionRepository repository;

  RenewSubscriptionUseCase(this.repository);

  @override
  Future<Either<Failure, SuccessResponse>> call(SubscribeRequest request) {
    return repository.renewSubscription(request);
  }
}
