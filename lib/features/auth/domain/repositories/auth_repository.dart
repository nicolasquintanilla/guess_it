import 'package:fpdart/fpdart.dart';
import 'package:guess_it/core/errors/failure.dart';
import 'package:guess_it/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginHost({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> registerHost({
    required String username,
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> playAsGuest();

  Future<Either<Failure, void>> logout();
}
