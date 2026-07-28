import '../../domain/repositories/qr_repository.dart';
import '../datasources/qr_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/generate_qr_request.dart';
import '../models/generated_qr_response.dart';
import '../models/my_qr_response.dart';
import '../models/delete_qr_request.dart';
import '../models/delete_qr_response.dart';

class QrRepositoryImpl implements QrRepository {
  final QrRemoteDataSource remoteDataSource;
  const QrRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, GeneratedQRResponse>> generateqr(
    GenerateQrRequest request,
  ) async {
    try {
      final result = await remoteDataSource.generateqr(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MyQRResponse>>> getmyqr() async {
    try {
      final result = await remoteDataSource.getmyqr();
         
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DeleteQrResponse>> deleteQr(
    DeleteQrRequest request,
  ) async {
    try {
      final result = await remoteDataSource.deleteQr(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
