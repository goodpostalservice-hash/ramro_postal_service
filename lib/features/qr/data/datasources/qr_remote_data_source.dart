import 'package:ramro_postal_service/core/constants/api_constants.dart';

import '../../../../core/network/api_client.dart';
import '../models/generate_qr_request.dart';
import '../models/generated_qr_response.dart';
import '../models/my_qr_response.dart';

import '../models/delete_qr_request.dart';
import '../models/delete_qr_response.dart';

abstract class QrRemoteDataSource {
  Future<GeneratedQRResponse> generateqr(GenerateQrRequest request);
  Future<List<MyQRResponse>> getmyqr();
  Future<DeleteQrResponse> deleteQr(DeleteQrRequest request);
}

class QrRemoteDataSourceImpl implements QrRemoteDataSource {
  final ApiClient apiClient;
  const QrRemoteDataSourceImpl({required this.apiClient});
  @override
  Future<GeneratedQRResponse> generateqr(GenerateQrRequest request) async {
    final response = await apiClient.post(
      ApiConstant.generateQR,
      data: request.toJson(),
      needToken: true,
    );

    return GeneratedQRResponse.fromJson(response.data);
  }

  @override
  Future<List<MyQRResponse>> getmyqr() async {
    final response = await apiClient.get(ApiConstant.myQR, needToken: true);
    final List<dynamic> data = response.data;
    return data.map((json) => MyQRResponse.fromJson(json)).toList();
  }

  @override
  Future<DeleteQrResponse> deleteQr(DeleteQrRequest request) async {
    final response = await apiClient.post(
      ApiConstant.deleteQR,
      data: request.toJson(),
      needToken: true,
    );

    return DeleteQrResponse.fromJson(response.data);
  }
}
