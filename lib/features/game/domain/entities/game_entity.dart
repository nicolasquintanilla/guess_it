import 'package:equatable/equatable.dart';
import 'package:guess_it/features/game/domain/entities/team_entity.dart';

/// Representa el estado global y configuración de una partida en curso.
///
/// Contiene la lista de equipos participantes, la ronda actual, el índice del
/// equipo que tiene el turno y configuraciones específicas de la partida.
class GameEntity extends Equatable {
  /// Lista de equipos ([TeamEntity]) que participan en la partida.
  final List<TeamEntity> teams;

  /// Ronda actual de la partida (ej: 1 para Tabú, 2 para Mímica).
  final int currentRound;

  /// Índice en la lista `teams` que indica qué equipo está jugando su turno.
  final int activeTeamIndex;

  /// Estado actual del flujo de la partida (ej: 'setup', 'playing', 'finished').
  final String gameStatus;

  /// Nombre del equipo anfitrión o creador de la partida.
  final String hostTeamName;

  /// Duración configurada para cada turno, expresada en segundos.
  final int turnDurationSeconds;

  /// Identificador opcional del grupo si la partida se juega dentro de un grupo cerrado.
  final String? groupId;

  /// Crea una instancia de [GameEntity].
  ///
  /// @param teams La lista de equipos.
  /// @param currentRound El número de ronda actual.
  /// @param activeTeamIndex El índice del equipo activo.
  /// @param gameStatus El estado actual del juego.
  /// @param hostTeamName El nombre del equipo host.
  /// @param turnDurationSeconds Los segundos por turno.
  /// @param groupId El ID del grupo (opcional).
  const GameEntity({
    required List<TeamEntity> teams,
    required int currentRound,
    required int activeTeamIndex,
    required String gameStatus,
    required String hostTeamName,
    required int turnDurationSeconds,
    String? groupId,
  })  : teams = teams,
        currentRound = currentRound,
        activeTeamIndex = activeTeamIndex,
        gameStatus = gameStatus,
        hostTeamName = hostTeamName,
        turnDurationSeconds = turnDurationSeconds,
        groupId = groupId;

  /// Crea una copia de este objeto modificando únicamente los campos proporcionados.
  ///
  /// @param teams Nueva lista de equipos (opcional).
  /// @param currentRound Nueva ronda actual (opcional).
  /// @param activeTeamIndex Nuevo índice del equipo activo (opcional).
  /// @param gameStatus Nuevo estado del juego (opcional).
  /// @param hostTeamName Nuevo nombre del equipo host (opcional).
  /// @param turnDurationSeconds Nueva duración de turno (opcional).
  /// @param groupId Nuevo ID de grupo (opcional).
  /// @return Una nueva instancia de [GameEntity] con los datos actualizados.
  GameEntity copyWith({
    List<TeamEntity>? teams,
    int? currentRound,
    int? activeTeamIndex,
    String? gameStatus,
    String? hostTeamName,
    int? turnDurationSeconds,
    String? groupId,
  }) {
    return GameEntity(
      teams: teams ?? this.teams,
      currentRound: currentRound ?? this.currentRound,
      activeTeamIndex: activeTeamIndex ?? this.activeTeamIndex,
      gameStatus: gameStatus ?? this.gameStatus,
      hostTeamName: hostTeamName ?? this.hostTeamName,
      turnDurationSeconds: turnDurationSeconds ?? this.turnDurationSeconds,
      groupId: groupId ?? this.groupId,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        teams,
        currentRound,
        activeTeamIndex,
        gameStatus,
        hostTeamName,
        turnDurationSeconds,
        groupId,
      ];
}
