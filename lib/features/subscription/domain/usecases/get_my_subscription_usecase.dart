import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/my_subscription_response.dart';
import '../repositories/subscription_repository.dart';

class GetMySubscriptionUseCase extends UseCase<MySubscriptionResponse, NoParams> {
  final SubscriptionRepository repository;

  GetMySubscriptionUseCase(this.repository);

  @override
  Future<Either<Failure, MySubscriptionResponse>> call(NoParams params) {
    return repository.getMySubscription();
  }
}
