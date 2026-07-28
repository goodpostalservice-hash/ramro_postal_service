import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/profile_response.dart';
import '../repositories/profile_repository.dart';

class GetprofileUseCase extends UseCase<ProfileResponse, NoParams> {
  final ProfileRepository repository;

  GetprofileUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileResponse>> call(NoParams params) {
    return repository.getprofile();
  }
}
