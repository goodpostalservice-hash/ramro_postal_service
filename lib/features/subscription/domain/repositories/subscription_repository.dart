import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../common/data/models/success_respone.dart';
import '../../data/models/my_subscription_response.dart';
import '../../data/models/subscribe_request.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, MySubscriptionResponse>> getMySubscription();



  Future<Either<Failure, SuccessResponse>> renewSubscription(
    SubscribeRequest request,
  );
  Future<Either<Failure, SuccessResponse>> subscribePackage(SubscribeRequest request);

}
