import 'package:equatable/equatable.dart';

class GameEntity extends Equatable {
  final String teamOneName;
  final String teamTwoName;
  final int teamOneScore;
  final int teamTwoScore;
  final int currentRound;
  final int activeTeam;
  final String gameStatus;

  const GameEntity({
    required String teamOneName,
    required String teamTwoName,
    required int teamOneScore,
    required int teamTwoScore,
    required int currentRound,
    required int activeTeam,
    required String gameStatus,
  })  : teamOneName = teamOneName,
        teamTwoName = teamTwoName,
        teamOneScore = teamOneScore,
        teamTwoScore = teamTwoScore,
        currentRound = currentRound,
        activeTeam = activeTeam,
        gameStatus = gameStatus;

  GameEntity copyWith({
    String? teamOneName,
    String? teamTwoName,
    int? teamOneScore,
    int? teamTwoScore,
    int? currentRound,
    int? activeTeam,
    String? gameStatus,
  }) {
    return GameEntity(
      teamOneName: teamOneName ?? this.teamOneName,
      teamTwoName: teamTwoName ?? this.teamTwoName,
      teamOneScore: teamOneScore ?? this.teamOneScore,
      teamTwoScore: teamTwoScore ?? this.teamTwoScore,
      currentRound: currentRound ?? this.currentRound,
      activeTeam: activeTeam ?? this.activeTeam,
      gameStatus: gameStatus ?? this.gameStatus,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        teamOneName,
        teamTwoName,
        teamOneScore,
        teamTwoScore,
        currentRound,
        activeTeam,
        gameStatus,
      ];
}
