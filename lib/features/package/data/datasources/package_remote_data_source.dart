import 'package:ramro_postal_service/core/constants/app_exports.dart';

import '../../../../core/network/api_client.dart';
import '../models/available_package.dart';

abstract class PackageRemoteDataSource {
  Future<List<AvailablePackageModel>> getPacakge();
}

class PackageRemoteDataSourceImpl implements PackageRemoteDataSource {
  final ApiClient apiClient;
  const PackageRemoteDataSourceImpl({required this.apiClient});
  @override
  Future<List<AvailablePackageModel>> getPacakge() async {
    final response = await apiClient.get(
      ApiConstant.availablePackages,
      needToken: true,
    );
    final List<dynamic> data = response.data;
    return data.map((json) => AvailablePackageModel.fromJson(json)).toList();
  }
}
