import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../common/data/models/success_respone.dart';
import '../../data/models/add_location_request.dart';
import '../../data/models/add_location_response.dart';
import '../../data/models/saved_address_response.dart';
import '../../data/models/save_address_request.dart';

abstract class AddressRepository {
  Future<Either<Failure, SavedAddressResponse>> getsavedaddress();

  Future<Either<Failure, SavedAddressResponse>> saveAddress(
    SaveAddressRequest request,
  );
  Future<Either<Failure, AddLocationResponse>> addMissingPlace(
    AddLocationRequest request,
  );
  Future<Either<Failure, SuccessResponse>> deleteSavedAddress(int id);

}
