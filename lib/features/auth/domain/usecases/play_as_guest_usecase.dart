import 'package:fpdart/fpdart.dart';
import 'package:guess_it/core/errors/failure.dart';
import 'package:guess_it/features/auth/domain/entities/user_entity.dart';
import 'package:guess_it/features/auth/domain/repositories/auth_repository.dart';

class PlayAsGuestUseCase {
  final AuthRepository repository;

  const PlayAsGuestUseCase({
    required AuthRepository repository,
  }) : repository = repository;

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.playAsGuest();
  }
}
