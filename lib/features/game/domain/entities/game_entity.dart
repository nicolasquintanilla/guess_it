import 'package:equatable/equatable.dart';
import 'package:guess_it/features/game/domain/entities/team_entity.dart';

class GameEntity extends Equatable {
  final List<TeamEntity> teams;
  final int currentRound;
  final int activeTeamIndex;
  final String gameStatus;
  final String hostTeamName;
  final int turnDurationSeconds;

  const GameEntity({
    required List<TeamEntity> teams,
    required int currentRound,
    required int activeTeamIndex,
    required String gameStatus,
    required String hostTeamName,
    required int turnDurationSeconds,
  })  : teams = teams,
        currentRound = currentRound,
        activeTeamIndex = activeTeamIndex,
        gameStatus = gameStatus,
        hostTeamName = hostTeamName,
        turnDurationSeconds = turnDurationSeconds;

  GameEntity copyWith({
    List<TeamEntity>? teams,
    int? currentRound,
    int? activeTeamIndex,
    String? gameStatus,
    String? hostTeamName,
    int? turnDurationSeconds,
  }) {
    return GameEntity(
      teams: teams ?? this.teams,
      currentRound: currentRound ?? this.currentRound,
      activeTeamIndex: activeTeamIndex ?? this.activeTeamIndex,
      gameStatus: gameStatus ?? this.gameStatus,
      hostTeamName: hostTeamName ?? this.hostTeamName,
      turnDurationSeconds: turnDurationSeconds ?? this.turnDurationSeconds,
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
      ];
}
