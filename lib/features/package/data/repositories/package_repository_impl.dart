import 'package:dartz/dartz.dart';
import 'package:ramro_postal_service/core/error/failures.dart';

import '../../domain/repositories/package_repository.dart';
import '../datasources/package_remote_data_source.dart';
import '../models/available_package.dart';

class PackageRepositoryImpl implements PackageRepository {
  final PackageRemoteDataSource remoteDataSource;
  const PackageRepositoryImpl({required this.remoteDataSource});

    @override
  Future<Either<Failure, List<AvailablePackageModel>>> getPacakge() async {
    try {
      final result = await remoteDataSource.getPacakge();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
