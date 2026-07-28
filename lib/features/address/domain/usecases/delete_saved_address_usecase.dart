import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../common/data/models/success_respone.dart';
import '../repositories/address_repository.dart';

class DeleteSavedAddressUseCase extends UseCase<SuccessResponse, int> {
  final AddressRepository repository;

  DeleteSavedAddressUseCase(this.repository);

  @override
  Future<Either<Failure, SuccessResponse>> call(int id) {
    return repository.deleteSavedAddress(id);
  }
}
