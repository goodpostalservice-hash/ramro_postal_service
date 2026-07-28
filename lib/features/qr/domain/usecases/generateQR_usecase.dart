import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/generate_qr_request.dart';
import '../../data/models/generated_qr_response.dart';
import '../repositories/qr_repository.dart';

class GenerateqrUseCase extends UseCase<GeneratedQRResponse, GenerateQrRequest> {
  final QrRepository repository;

  GenerateqrUseCase(this.repository);

  @override
  Future<Either<Failure, GeneratedQRResponse>> call(GenerateQrRequest request) {
    return repository.generateqr(request);
  }
}
