import '../../domain/repositories/common_repository.dart';
import '../datasources/common_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/location_name_request.dart';
import '../models/location_data_response.dart';


class CommonRepositoryImpl implements CommonRepository {
  final CommonRemoteDataSource remoteDataSource;
  const CommonRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, LocationDataResponse>> getLocationName(
    LocationNameRequest request,
  ) async {
    try {
      final result = await remoteDataSource.getLocationName(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }



}
