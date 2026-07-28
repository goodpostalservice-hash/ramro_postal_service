import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/saved_address_response.dart';
import '../repositories/address_repository.dart';

class GetsavedaddressUseCase extends UseCase<SavedAddressResponse, NoParams> {
  final AddressRepository repository;

  GetsavedaddressUseCase(this.repository);

  @override
  Future<Either<Failure, SavedAddressResponse>> call(NoParams params) {
    return repository.getsavedaddress();
  }
}
