import '../../../../core/network/api_client.dart';

abstract class NotificationRemoteDataSource {
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient apiClient;
  const NotificationRemoteDataSourceImpl({required this.apiClient});
}
