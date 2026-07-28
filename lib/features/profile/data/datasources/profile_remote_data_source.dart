import 'package:ramro_postal_service/core/constants/api_constants.dart';

import '../../../../core/network/api_client.dart';
import '../models/profile_response.dart';
import '../models/update_profile_request.dart';
import '../models/update_profile_response.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileResponse> getprofile();
  Future<UpdateProfileResponse> updateProfile(UpdateProfileRequest request);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;
  const ProfileRemoteDataSourceImpl({required this.apiClient});
  @override
  Future<ProfileResponse> getprofile() async {
    final response = await apiClient.get(ApiConstant.profile, needToken: true);

    return ProfileResponse.fromJson(response.data);
  }

  @override
  Future<UpdateProfileResponse> updateProfile(
    UpdateProfileRequest request,
  ) async {
    final response = await apiClient.post(
      ApiConstant.updateProfile,
      queryParameters: request.toJson(),
      needToken: true,
    );

    return UpdateProfileResponse.fromJson(response.data);
  }
}
