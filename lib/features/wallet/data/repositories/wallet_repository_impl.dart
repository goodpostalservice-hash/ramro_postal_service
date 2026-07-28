import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/user_wallet.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;
  const WalletRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, UserWallet>> getWallet() async {
    try {
      final result = await remoteDataSource.getWallet();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


}
