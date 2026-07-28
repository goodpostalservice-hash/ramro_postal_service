import 'package:ramro_postal_service/core/constants/app_exports.dart';

import '../../../../core/network/api_client.dart';
import '../models/terms_data.dart';
import '../models/privacy_data.dart';

abstract class SettingsRemoteDataSource {
  Future<TermsData> getTermsAndConditions();
  Future<PrivacyData> getPrivacyPolicy();
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final ApiClient apiClient;
  const SettingsRemoteDataSourceImpl({required this.apiClient});
  @override
  Future<TermsData> getTermsAndConditions() async {
    final response = await apiClient.get(
      ApiConstant.termsAndConditions,
      needToken: false,
    );

    return TermsData.fromJson(response.data);
  }

  @override
  Future<PrivacyData> getPrivacyPolicy() async {
    final response = await apiClient.get(
      ApiConstant.privacyPolicy,
      needToken: false,
    );

    return PrivacyData.fromJson(response.data);
  }
}
