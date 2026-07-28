import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/update_profile_request.dart';
import '../../data/models/update_profile_response.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase
    extends UseCase<UpdateProfileResponse, UpdateProfileRequest> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UpdateProfileResponse>> call(
    UpdateProfileRequest request,
  ) {
    return repository.updateProfile(request);
  }
}
