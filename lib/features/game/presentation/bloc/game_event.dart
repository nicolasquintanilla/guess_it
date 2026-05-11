import 'package:equatable/equatable.dart';
import 'package:guess_it/features/game/domain/entities/team_entity.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class InitializeGameEvent extends GameEvent {
  final List<TeamEntity> initialTeams;
  final List<String> userWords;
  final int targetWordCount;
  final String hostTeamName;
  final int turnDurationSeconds;

  const InitializeGameEvent({
    required List<TeamEntity> initialTeams,
    required List<String> userWords,
    required int targetWordCount,
    required String hostTeamName,
    required int turnDurationSeconds,
  })  : initialTeams = initialTeams,
        userWords = userWords,
        targetWordCount = targetWordCount,
        hostTeamName = hostTeamName,
        turnDurationSeconds = turnDurationSeconds;

  @override
  List<Object?> get props => <Object?>[
        initialTeams,
        userWords,
        targetWordCount,
        hostTeamName,
        turnDurationSeconds,
      ];
}

class AddPointsEvent extends GameEvent {
  final int points;

  const AddPointsEvent({
    required int points,
  }) : points = points;

  @override
  List<Object?> get props => <Object?>[points];
}

class SwitchTurnEvent extends GameEvent {
  const SwitchTurnEvent();
}

class EndGameEvent extends GameEvent {
  const EndGameEvent();
}

class StartTurnEvent extends GameEvent {
  const StartTurnEvent();
}

class TickTimerEvent extends GameEvent {
  const TickTimerEvent();
}

class CorrectAnswerEvent extends GameEvent {
  const CorrectAnswerEvent();
}

class SkipWordEvent extends GameEvent {
  const SkipWordEvent();
}

class PauseGameEvent extends GameEvent {
  const PauseGameEvent();
}

class ResumeGameEvent extends GameEvent {
  const ResumeGameEvent();
}

class TimeUpEvent extends GameEvent {
  const TimeUpEvent();
}

class ToggleWordReviewEvent extends GameEvent {
  final String word;
  final bool wasGuessed;

  const ToggleWordReviewEvent({
    required String word,
    required bool wasGuessed,
  })  : word = word,
        wasGuessed = wasGuessed;

  @override
  List<Object?> get props => <Object?>[word, wasGuessed];
}

class ResetGameEvent extends GameEvent {
  const ResetGameEvent();
}
