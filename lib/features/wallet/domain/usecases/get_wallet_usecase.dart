import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/user_wallet.dart';
import '../repositories/wallet_repository.dart';

class GetWalletUseCase extends UseCase<UserWallet, NoParams> {
  final WalletRepository repository;

  GetWalletUseCase(this.repository);

  @override
  Future<Either<Failure, UserWallet>> call(NoParams params) {
    return repository.getWallet();
  }
}
