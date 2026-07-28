import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/search_request.dart';
import '../../data/models/search_response.dart';
import '../repositories/search_repository.dart';

class GetSearchResultUseCase extends UseCase<SearchResponse, SearchRequest> {
  final SearchRepository repository;

  GetSearchResultUseCase(this.repository);

  @override
  Future<Either<Failure, SearchResponse>> call(SearchRequest request) {
    return repository.getSearchResult(request);
  }
}
