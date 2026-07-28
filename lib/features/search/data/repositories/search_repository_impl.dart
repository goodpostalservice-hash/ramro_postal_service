import 'package:dartz/dartz.dart';
import 'package:ramro_postal_service/core/error/failures.dart';

import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';
import '../models/search_request.dart';
import '../models/search_response.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  const SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SearchResponse>> getSearchResult(
    SearchRequest request,
  ) async {
    try {
      final result = await remoteDataSource.getSearchResult(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
