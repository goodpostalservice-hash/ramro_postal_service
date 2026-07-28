import '../../../common/data/models/success_respone.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/my_subscription_response.dart';
import '../models/subscribe_request.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remoteDataSource;
  const SubscriptionRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, MySubscriptionResponse>> getMySubscription() async {
    try {
      final result = await remoteDataSource.getMySubscription();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }





  @override
  Future<Either<Failure, SuccessResponse>> renewSubscription(SubscribeRequest request) async {
    try {
      final result = await remoteDataSource.renewSubscription(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, SuccessResponse>> subscribePackage(SubscribeRequest request) async {
    try {
      final result = await remoteDataSource.subscribePackage(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


}
