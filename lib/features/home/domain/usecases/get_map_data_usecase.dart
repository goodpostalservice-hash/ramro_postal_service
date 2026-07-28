import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/map_data_request.dart';
import '../../data/models/map_data_response.dart';
import '../repositories/home_repository.dart';

class GetMapDataUseCase extends UseCase<MapDataResponse, MapDataRequest> {
  final HomeRepository repository;

  GetMapDataUseCase(this.repository);

  @override
  Future<Either<Failure, MapDataResponse>> call(MapDataRequest request) {
    return repository.getMapData(request);
  }
}
