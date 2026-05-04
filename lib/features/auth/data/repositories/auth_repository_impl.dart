import 'package:fpdart/fpdart.dart';
import 'package:guess_it/core/errors/failure.dart';
import 'package:guess_it/features/auth/domain/entities/user_entity.dart';
import 'package:guess_it/features/auth/domain/repositories/auth_repository.dart';
import 'package:guess_it/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:guess_it/features/auth/data/datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : remoteDataSource = remoteDataSource,
        localDataSource = localDataSource;

  @override
  Future<Either<Failure, UserEntity>> loginHost({
    required String email,
    required String password,
  }) async {
    try {
      final UserEntity user = await remoteDataSource.loginHost(
        email: email,
        password: password,
      );
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerHost({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final UserEntity user = await remoteDataSource.registerHost(
        username: username,
        email: email,
        password: password,
      );
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> playAsGuest() async {
    try {
      final UserEntity user = await localDataSource.playAsGuest();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
