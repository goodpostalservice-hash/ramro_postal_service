import '../../../common/data/models/success_respone.dart';
import '../models/add_location_request.dart';
import '../models/add_location_response.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/saved_address_response.dart';
import '../models/save_address_request.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;
  const AddressRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, SavedAddressResponse>> getsavedaddress() async {
    try {
      final result = await remoteDataSource.getsavedaddress();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavedAddressResponse>> saveAddress(
    SaveAddressRequest request,
  ) async {
    try {
      final result = await remoteDataSource.saveAddress(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AddLocationResponse>> addMissingPlace(
    AddLocationRequest request,
  ) async {
    try {
      final result = await remoteDataSource.addMissingPlace(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SuccessResponse>> deleteSavedAddress(int id) async {
    try {
      final result = await remoteDataSource.deleteSavedAddress(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
