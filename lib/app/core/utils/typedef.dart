import 'package:dartz/dartz.dart';

import '../configuration/app_entity.dart';

typedef ResultFuture<T> = Future<Either<String, AppEntity<T>>>;
