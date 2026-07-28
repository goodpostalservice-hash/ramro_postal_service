import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/profile_response.dart';
import '../../data/models/update_profile_request.dart';
import '../../data/models/update_profile_response.dart';
abstract class ProfileRepository {
  Future<Either<Failure, ProfileResponse>> getprofile();

  Future<Either<Failure, UpdateProfileResponse>> updateProfile(UpdateProfileRequest request);

}
