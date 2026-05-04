import 'package:fpdart/fpdart.dart';
import 'package:guess_it/core/errors/failure.dart';
import 'package:guess_it/features/auth/domain/entities/user_entity.dart';
import 'package:guess_it/features/auth/domain/repositories/auth_repository.dart';

class RegisterHostUseCase {
  final AuthRepository repository;

  const RegisterHostUseCase({
    required AuthRepository repository,
  }) : repository = repository;

  Future<Either<Failure, UserEntity>> call({
    required String username,
    required String email,
    required String password,
  }) async {
    return await repository.registerHost(
      username: username,
      email: email,
      password: password,
    );
  }
}
