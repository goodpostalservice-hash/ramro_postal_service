import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/terms_data.dart';
import '../models/privacy_data.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;
  const SettingsRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, TermsData>> getTermsAndConditions() async {
    try {
      final result = await remoteDataSource.getTermsAndConditions();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, PrivacyData>> getPrivacyPolicy() async {
    try {
      final result = await remoteDataSource.getPrivacyPolicy();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


}
