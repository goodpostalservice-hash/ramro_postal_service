import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/location_name_request.dart';
import '../../data/models/location_data_response.dart';
import '../repositories/common_repository.dart';

class GetLocationNameUseCase extends UseCase<LocationDataResponse, LocationNameRequest> {
  final CommonRepository repository;

  GetLocationNameUseCase(this.repository);

  @override
  Future<Either<Failure, LocationDataResponse>> call(LocationNameRequest request) {
    return repository.getLocationName(request);
  }
}
