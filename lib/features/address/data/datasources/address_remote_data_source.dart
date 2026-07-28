import 'package:ramro_postal_service/core/constants/api_constants.dart';

import '../../../../core/network/api_client.dart';
import '../../../common/data/models/success_respone.dart';
import '../models/add_location_request.dart';
import '../models/add_location_response.dart';
import '../models/saved_address_response.dart';
import '../models/save_address_request.dart';

abstract class AddressRemoteDataSource {
  Future<SavedAddressResponse> getsavedaddress();
  Future<SavedAddressResponse> saveAddress(SaveAddressRequest request);
  Future<AddLocationResponse> addMissingPlace(AddLocationRequest request);
  Future<SuccessResponse> deleteSavedAddress(int id);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final ApiClient apiClient;
  const AddressRemoteDataSourceImpl({required this.apiClient});
  @override
  Future<SavedAddressResponse> getsavedaddress() async {
    final response = await apiClient.get(
      ApiConstant.getSavedAddress,
      needToken: true,
    );

    return SavedAddressResponse.fromJson(response.data);
  }

  @override
  Future<SavedAddressResponse> saveAddress(SaveAddressRequest request) async {
    final response = await apiClient.post(
      ApiConstant.saveAddress,
      data: request.toJson(),
      needToken: true,
    );

    return SavedAddressResponse.fromJson(response.data);
  }

  @override
  Future<AddLocationResponse> addMissingPlace(
    AddLocationRequest request,
  ) async {
    final response = await apiClient.post(
      ApiConstant.addMissingPlace,
      data: request.toJson(),
      needToken: true,
    );

    return AddLocationResponse.fromJson(response.data);
  }

  @override
  Future<SuccessResponse> deleteSavedAddress(int id) async {
    final response = await apiClient.get(
      ApiConstant.deleteSavedAddress(id),
      needToken: true,
    );

    return SuccessResponse.fromJson(response.data);
  }
}
