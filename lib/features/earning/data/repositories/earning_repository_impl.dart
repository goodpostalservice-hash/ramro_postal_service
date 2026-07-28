import '../../domain/repositories/earning_repository.dart';
import '../datasources/earning_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/today_earning_response.dart';
import '../models/earning_response.dart';

class EarningRepositoryImpl implements EarningRepository {
  final EarningRemoteDataSource remoteDataSource;
  const EarningRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, TodayEarningResponse>> getTodayEarning() async {
    try {
      final result = await remoteDataSource.getTodayEarning();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, EarningResponse>> getEarning() async {
    try {
      final result = await remoteDataSource.getEarning();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


}
