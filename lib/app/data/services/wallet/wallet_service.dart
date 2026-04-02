import 'package:dartz/dartz.dart';
import 'package:ramro_postal_service/app/core/configuration/http_config.dart';
import 'package:ramro_postal_service/app/data/models/user_wallet/user_wallet.dart';

import '../../../core/configuration/api.dart';

class WalletService {
  static Future<Either<String, UserWallet>> getWalletData() async {
    var res = await SApi().get(HttpConfig.wallet, addAuthInterceptor: true);

    if (res.isSuccess) {
      late UserWallet data;
      try {
        data = UserWallet.fromMap(res.data ?? {});
      } catch (e) {
        return Left("data parsing error: $e");
      }
      return Right(data);
    } else {
      return Left(res.message ?? "something went wrong");
    }
  }
}
