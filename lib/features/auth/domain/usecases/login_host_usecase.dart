import 'package:fpdart/fpdart.dart';
import 'package:guess_it/core/errors/failure.dart';
import 'package:guess_it/features/auth/domain/entities/user_entity.dart';
import 'package:guess_it/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso que encapsula la lógica para iniciar sesión como anfitrión.
///
/// Llama al [AuthRepository] para autenticar al usuario utilizando su
/// correo electrónico y contraseña.
class LoginHostUseCase {
  /// Repositorio de autenticación que maneja la persistencia y la API.
  final AuthRepository repository;

  /// Crea una instancia de [LoginHostUseCase].
  ///
  /// @param repository El repositorio de autenticación inyectado.
  const LoginHostUseCase({
    required AuthRepository repository,
  }) : repository = repository;

  /// Ejecuta el caso de uso para iniciar sesión.
  ///
  /// @param email El correo electrónico del usuario.
  /// @param password La contraseña secreta del usuario.
  /// @return Un [Either] con un [Failure] en caso de error, o un [UserEntity] en caso de éxito.
  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await repository.loginHost(email: email, password: password);
  }
}
