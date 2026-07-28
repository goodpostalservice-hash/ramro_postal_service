import 'package:ramro_postal_service/core/constants/app_exports.dart';

import '../../../../core/network/api_client.dart';
import '../models/map_data_request.dart';
import '../models/map_data_response.dart';

abstract class HomeRemoteDataSource {
  Future<MapDataResponse> getMapData(MapDataRequest request);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;
  const HomeRemoteDataSourceImpl({required this.apiClient});
  @override
  Future<MapDataResponse> getMapData(MapDataRequest request) async {
    final response = await apiClient.get(
     ApiConstant.houseNumber,
      queryParameters: request.toJson(),
      needToken: true,
    );

    return MapDataResponse.fromJson(response.data);
  }


}
