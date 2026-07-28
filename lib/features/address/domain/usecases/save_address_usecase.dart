import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/save_address_request.dart';
import '../../data/models/saved_address_response.dart';
import '../repositories/address_repository.dart';

class SaveAddressUseCase extends UseCase<SavedAddressResponse, SaveAddressRequest> {
  final AddressRepository repository;

  SaveAddressUseCase(this.repository);

  @override
  Future<Either<Failure, SavedAddressResponse>> call(SaveAddressRequest request) {
    return repository.saveAddress(request);
  }
}
