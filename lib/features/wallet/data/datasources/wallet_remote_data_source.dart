import 'package:ramro_postal_service/core/constants/api_constants.dart';

import '../../../../core/network/api_client.dart';
import '../models/user_wallet.dart';

abstract class WalletRemoteDataSource {
  Future<UserWallet> getWallet();
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final ApiClient apiClient;
  const WalletRemoteDataSourceImpl({required this.apiClient});
  @override
  Future<UserWallet> getWallet() async {
    final response = await apiClient.get(
      ApiConstant.wallet,
      needToken: true,
    );

    return UserWallet.fromJson(response.data);
  }


}
