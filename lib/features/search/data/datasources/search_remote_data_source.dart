import 'package:ramro_postal_service/core/constants/api_constants.dart';

import '../../../../core/network/api_client.dart';
import '../models/search_request.dart';
import '../models/search_response.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResponse> getSearchResult(SearchRequest request);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiClient apiClient;
  const SearchRemoteDataSourceImpl({required this.apiClient});

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
