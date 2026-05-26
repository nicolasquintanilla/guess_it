import 'package:fpdart/fpdart.dart';
import 'package:guess_it/core/errors/failure.dart';
import 'package:guess_it/features/auth/domain/entities/user_entity.dart';

/// Contrato del repositorio de autenticación en la capa de dominio.
///
/// Define las operaciones principales relacionadas con la autenticación y
/// gestión de sesión, separando la lógica de negocio de la implementación
/// concreta de persistencia (Firebase, LocalStorage, etc.).
abstract class AuthRepository {
  /// Inicia sesión como anfitrión utilizando correo y contraseña.
  ///
  /// @param email El correo electrónico registrado.
  /// @param password La contraseña del usuario.
  /// @return Un [Either] con un [Failure] en caso de error, o un [UserEntity] en caso de éxito.
  Future<Either<Failure, UserEntity>> loginHost({
    required String email,
    required String password,
  });

  /// Registra una nueva cuenta de anfitrión en la plataforma.
  ///
  /// @param username El nombre de visualización del nuevo usuario.
  /// @param email El correo electrónico del nuevo usuario.
  /// @param password La contraseña para la nueva cuenta.
  /// @return Un [Either] con un [Failure] en caso de error, o el nuevo [UserEntity] creado.
  Future<Either<Failure, UserEntity>> registerHost({
    required String username,
    required String email,
    required String password,
  });

  /// Crea e inicia una sesión temporal como invitado.
  ///
  /// @return Un [Either] con un [Failure] en caso de error, o el [UserEntity] temporal.
  Future<Either<Failure, UserEntity>> playAsGuest();

  /// Cierra la sesión activa actual del usuario.
  ///
  /// @return Un [Either] con un [Failure] en caso de error, o `void` si se cierra exitosamente.
  Future<Either<Failure, void>> logout();
}
