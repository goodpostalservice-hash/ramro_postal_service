import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/available_package.dart';

abstract class PackageRepository {
    Future<Either<Failure, List<AvailablePackageModel>>> getPacakge();
}
