import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/delete_qr_request.dart';
import '../../data/models/delete_qr_response.dart';
import '../repositories/qr_repository.dart';

class DeleteQrUseCase extends UseCase<DeleteQrResponse, DeleteQrRequest> {
  final QrRepository repository;

  DeleteQrUseCase(this.repository);

  @override
  Future<Either<Failure, DeleteQrResponse>> call(DeleteQrRequest request) {
    return repository.deleteQr(request);
  }
}
