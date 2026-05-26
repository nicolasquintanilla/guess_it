import 'package:equatable/equatable.dart';

/// Representa a un usuario (Anfitrión o Invitado) dentro del dominio de la aplicación.
///
/// Contiene la información esencial del perfil, estadísticas globales de juego y
/// preferencias de visualización (avatar).
class UserEntity extends Equatable {
  /// Identificador único del usuario (UUID para invitados, UID de Firebase para registrados).
  final String id;

  /// Nombre de visualización elegido por el usuario.
  final String username;

  /// Indica si el usuario está jugando en modo local sin cuenta permanente (`true`)
  /// o si es un usuario registrado en la base de datos (`false`).
  final bool isGuest;

  /// Fecha de creación del usuario en formato ISO 8601.
  final String createdAt;

  /// Cantidad total de partidas en las que ha participado el usuario.
  final int gamesPlayed;

  /// Cantidad total de victorias obtenidas por el usuario.
  final int victories;

  /// Identificador del avatar seleccionado por el usuario.
  final String avatar;

  /// Crea una instancia de [UserEntity].
  ///
  /// @param id Identificador único.
  /// @param username Nombre público.
  /// @param isGuest Estado de autenticación (invitado o registrado).
  /// @param createdAt Fecha de creación de la cuenta o sesión.
  /// @param gamesPlayed Número de partidas jugadas.
  /// @param victories Número de victorias.
  /// @param avatar Identificador del icono o imagen de perfil (por defecto 'default').
  const UserEntity({
    required String id,
    required String username,
    required bool isGuest,
    required String createdAt,
    required int gamesPlayed,
    required int victories,
    String avatar = 'default',
  })  : id = id,
        username = username,
        isGuest = isGuest,
        createdAt = createdAt,
        gamesPlayed = gamesPlayed,
        victories = victories,
        avatar = avatar;

  /// Crea una copia de este objeto modificando únicamente los campos proporcionados.
  ///
  /// @param id Nuevo identificador único (opcional).
  /// @param username Nuevo nombre de usuario (opcional).
  /// @param isGuest Nuevo estado de invitado (opcional).
  /// @param createdAt Nueva fecha de creación (opcional).
  /// @param gamesPlayed Nuevo contador de partidas jugadas (opcional).
  /// @param victories Nuevo contador de victorias (opcional).
  /// @param avatar Nuevo avatar (opcional).
  /// @return Una nueva instancia de [UserEntity] con los datos actualizados.
  UserEntity copyWith({
    String? id,
    String? username,
    bool? isGuest,
    String? createdAt,
    int? gamesPlayed,
    int? victories,
    String? avatar,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      isGuest: isGuest ?? this.isGuest,
      createdAt: createdAt ?? this.createdAt,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      victories: victories ?? this.victories,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  List<Object?> get props => <Object?>[id, username, isGuest, createdAt, gamesPlayed, victories, avatar];
}
