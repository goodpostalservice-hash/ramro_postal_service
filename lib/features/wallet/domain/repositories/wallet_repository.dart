import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/user_wallet.dart';
abstract class WalletRepository {
  Future<Either<Failure, UserWallet>> getWallet();

}
