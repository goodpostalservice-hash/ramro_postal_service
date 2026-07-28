import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/location_name_request.dart';
import '../../data/models/location_data_response.dart';
import '../../../address/data/models/add_location_request.dart';
import '../../../address/data/models/add_location_response.dart';

abstract class CommonRepository {
  Future<Either<Failure, LocationDataResponse>> getLocationName(
    LocationNameRequest request,
  );
 

}
