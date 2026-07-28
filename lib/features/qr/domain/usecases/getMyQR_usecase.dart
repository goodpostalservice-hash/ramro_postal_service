import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/my_qr_response.dart';
import '../repositories/qr_repository.dart';

class GetmyqrUseCase extends UseCase<List<MyQRResponse>, NoParams> {
  final QrRepository repository;

  GetmyqrUseCase(this.repository);

  @override
  Future<Either<Failure, List<MyQRResponse>>> call(NoParams params) {
    return repository.getmyqr();
  }
}
