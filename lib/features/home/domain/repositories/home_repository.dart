import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/map_data_request.dart';
import '../../data/models/map_data_response.dart';
abstract class HomeRepository {
  Future<Either<Failure, MapDataResponse>> getMapData(MapDataRequest request);

}
