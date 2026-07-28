import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/profile_response.dart';
import '../models/update_profile_request.dart';
import '../models/update_profile_response.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  const ProfileRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, ProfileResponse>> getprofile() async {
    try {
      final result = await remoteDataSource.getprofile();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, UpdateProfileResponse>> updateProfile(UpdateProfileRequest request) async {
    try {
      final result = await remoteDataSource.updateProfile(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


}
