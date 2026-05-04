import 'package:fpdart/fpdart.dart';
import 'package:guess_it/core/errors/failure.dart';
import 'package:guess_it/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  const LogoutUseCase({
    required AuthRepository repository,
  }) : repository = repository;

  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}
