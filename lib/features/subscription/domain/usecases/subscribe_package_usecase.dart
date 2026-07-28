import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../common/data/models/success_respone.dart';
import '../../data/models/subscribe_request.dart';
import '../repositories/subscription_repository.dart';

class SubscribePackageUseCase extends UseCase<SuccessResponse, SubscribeRequest> {
  final SubscriptionRepository repository;

  SubscribePackageUseCase(this.repository);

  @override
  Future<Either<Failure, SuccessResponse>> call(SubscribeRequest request) {
    return repository.subscribePackage(request);
  }
}
