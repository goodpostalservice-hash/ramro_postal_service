import '../../../../core/network/api_client.dart';

abstract class DashboardRemoteDataSource {
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient apiClient;
  const DashboardRemoteDataSourceImpl({required this.apiClient});
}
