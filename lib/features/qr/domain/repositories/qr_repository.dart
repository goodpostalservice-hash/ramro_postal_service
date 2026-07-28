import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/generate_qr_request.dart';
import '../../data/models/generated_qr_response.dart';
import '../../data/models/my_qr_response.dart';
import '../../data/models/delete_qr_request.dart';
import '../../data/models/delete_qr_response.dart';

abstract class QrRepository {
  Future<Either<Failure, GeneratedQRResponse>> generateqr(
    GenerateQrRequest request,
  );

  Future<Either<Failure, List<MyQRResponse>>> getmyqr();

  Future<Either<Failure, DeleteQrResponse>> deleteQr(DeleteQrRequest request);
}
