import 'package:dartz/dartz.dart';
import 'package:ramro_postal_service/core/error/failures.dart';

import '../../data/models/search_request.dart';
import '../../data/models/search_response.dart';

abstract class SearchRepository {
  Future<Either<Failure, SearchResponse>> getSearchResult(
    SearchRequest request,
  );
}
