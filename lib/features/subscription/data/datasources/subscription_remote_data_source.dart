import 'package:ramro_postal_service/core/constants/api_constants.dart';

import '../../../../core/network/api_client.dart';
import '../../../common/data/models/success_respone.dart';
import '../models/my_subscription_response.dart';
import '../models/subscribe_request.dart';

abstract class SubscriptionRemoteDataSource {
  Future<MySubscriptionResponse> getMySubscription();

  Future<SuccessResponse> renewSubscription(SubscribeRequest request);
  Future<SuccessResponse> subscribePackage(SubscribeRequest request);
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final ApiClient apiClient;
  const SubscriptionRemoteDataSourceImpl({required this.apiClient});
  @override
  Future<MySubscriptionResponse> getMySubscription() async {
    final response = await apiClient.get(
      ApiConstant.subscription,
      needToken: true,
    );

    return MySubscriptionResponse.fromJson(response.data);
  }



  @override
  Future<SuccessResponse> renewSubscription(SubscribeRequest request) async {
    final response = await apiClient.post(
      ApiConstant.renewSubscription,
      data: request.toJson(),
      needToken: true,
    );

    return SuccessResponse.fromJson(response.data);
  }
  @override
  Future<SuccessResponse> subscribePackage(SubscribeRequest request) async {
    final response = await apiClient.post(
      '/subscribe',
      data: request.toJson(),
      needToken: true,
    );

    return SuccessResponse.fromJson(response.data);
  }


}
