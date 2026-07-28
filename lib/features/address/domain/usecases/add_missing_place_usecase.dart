import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/add_location_request.dart';
import '../../data/models/add_location_response.dart';
import '../repositories/address_repository.dart';

class AddMissingPlaceUseCase
    extends UseCase<AddLocationResponse, AddLocationRequest> {
  final AddressRepository repository;

  AddMissingPlaceUseCase(this.repository);

  @override
  Future<Either<Failure, AddLocationResponse>> call(
    AddLocationRequest request,
  ) {
    return repository.addMissingPlace(request);
  }
}
