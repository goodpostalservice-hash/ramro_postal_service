import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/map_data_request.dart';
import '../models/map_data_response.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  const HomeRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, MapDataResponse>> getMapData(MapDataRequest request) async {
    try {
      final result = await remoteDataSource.getMapData(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


}
