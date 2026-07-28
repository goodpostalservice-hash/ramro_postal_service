import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/terms_data.dart';
import '../../data/models/privacy_data.dart';
abstract class SettingsRepository {
  Future<Either<Failure, TermsData>> getTermsAndConditions();

  Future<Either<Failure, PrivacyData>> getPrivacyPolicy();

}
