import 'package:ramro_postal_service/core/constants/app_exports.dart';

import '../../../../core/network/api_client.dart';
import '../models/location_name_request.dart';
import '../models/location_data_response.dart';
import '../../../search/data/models/search_request.dart';
import '../../../search/data/models/search_response.dart';
import '../../../address/data/models/add_location_request.dart';
import '../../../address/data/models/add_location_response.dart';

abstract class CommonRemoteDataSource {
  Future<LocationDataResponse> getLocationName(LocationNameRequest request);
  Future<SearchResponse> getSearchResult(SearchRequest request);
  
}

class CommonRemoteDataSourceImpl implements CommonRemoteDataSource {
  final ApiClient apiClient;
  const CommonRemoteDataSourceImpl({required this.apiClient});
  @override
  Future<LocationDataResponse> getLocationName(
    LocationNameRequest request,
  ) async {
    final response = await apiClient.get(
      ApiConstant.locationName,
      queryParameters: request.toJson(),
      needToken: true,
    );

    return LocationDataResponse.fromJson(response.data);
  }

  @override
  Future<SearchResponse> getSearchResult(SearchRequest request) async {
    final response = await apiClient.get(
      ApiConstant.searchResult,
      queryParameters: request.toJson(),
      needToken: false,
    );

    return SearchResponse.fromJson(response.data);
  }



}
