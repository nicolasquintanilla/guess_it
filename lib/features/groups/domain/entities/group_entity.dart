import 'package:equatable/equatable.dart';

/// Entidad de dominio que representa un grupo de amigos o jugadores.
///
/// Los grupos permiten a los usuarios organizar partidas frecuentes,
/// llevar un registro de puntuaciones históricas (ranking) y unirse
/// rápidamente mediante un código de invitación.
class GroupEntity extends Equatable {
  /// Identificador único del grupo (generado en la base de datos).
  final String id;

  /// Nombre visible del grupo.
  final String name;

  /// Identificador del usuario creador y administrador del grupo.
  final String hostId;

  /// Código único y corto de 6 caracteres utilizado para invitar a nuevos miembros.
  final String joinCode;

  /// Lista con los nombres de visualización de todos los integrantes.
  final List<String> memberNames;

  /// Lista con los correos electrónicos de los integrantes.
  final List<String> memberEmails;

  /// Fecha de creación del grupo en formato ISO 8601.
  final String createdAt;

  /// Mapa que asocia el correo electrónico de un jugador con su puntuación acumulada en el grupo.
  final Map<String, int> scores;

  /// Crea una instancia de [GroupEntity].
  ///
  /// @param id ID único del grupo.
  /// @param name Nombre del grupo.
  /// @param hostId ID del anfitrión.
  /// @param joinCode Código de invitación.
  /// @param memberNames Lista de nombres de miembros.
  /// @param memberEmails Lista de correos de miembros.
  /// @param createdAt Fecha de creación.
  /// @param scores Mapa opcional de puntuaciones iniciales.
  const GroupEntity({
    required this.id,
    required this.name,
    required this.hostId,
    required this.joinCode,
    required this.memberNames,
    required this.memberEmails,
    required this.createdAt,
    Map<String, int> scores = const <String, int>{},
  }) : scores = scores;

  /// Crea una copia de este grupo modificando únicamente los campos proporcionados.
  ///
  /// @param id Nuevo identificador (opcional).
  /// @param name Nuevo nombre del grupo (opcional).
  /// @param hostId Nuevo anfitrión (opcional).
  /// @param joinCode Nuevo código de invitación (opcional).
  /// @param memberNames Nueva lista de nombres (opcional).
  /// @param memberEmails Nueva lista de correos (opcional).
  /// @param createdAt Nueva fecha (opcional).
  /// @param scores Nuevo mapa de puntuaciones (opcional).
  /// @return Una nueva instancia de [GroupEntity] con los datos actualizados.
  GroupEntity copyWith({
    String? id,
    String? name,
    String? hostId,
    String? joinCode,
    List<String>? memberNames,
    List<String>? memberEmails,
    String? createdAt,
    Map<String, int>? scores,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      hostId: hostId ?? this.hostId,
      joinCode: joinCode ?? this.joinCode,
      memberNames: memberNames ?? this.memberNames,
      memberEmails: memberEmails ?? this.memberEmails,
      createdAt: createdAt ?? this.createdAt,
      scores: scores ?? this.scores,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        hostId,
        joinCode,
        memberNames,
        memberEmails,
        createdAt,
        scores,
      ];
}
