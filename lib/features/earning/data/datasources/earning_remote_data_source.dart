import 'package:ramro_postal_service/core/constants/app_exports.dart';

import '../../../../core/network/api_client.dart';
import '../models/today_earning_response.dart';
import '../models/earning_response.dart';

abstract class EarningRemoteDataSource {
  Future<TodayEarningResponse> getTodayEarning();
  Future<EarningResponse> getEarning();
}

class EarningRemoteDataSourceImpl implements EarningRemoteDataSource {
  final ApiClient apiClient;
  const EarningRemoteDataSourceImpl({required this.apiClient});
  @override
  Future<TodayEarningResponse> getTodayEarning() async {
    final response = await apiClient.get(
      ApiConstant.todayEarning,
      needToken: true,
    );

    return TodayEarningResponse.fromJson(response.data);
  }


  @override
  Future<EarningResponse> getEarning() async {
    final response = await apiClient.get(
      ApiConstant.earning,
      needToken: true,
    );

    return EarningResponse.fromJson(response.data);
  }


}
