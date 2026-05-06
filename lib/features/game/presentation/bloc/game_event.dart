import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class InitializeGameEvent extends GameEvent {
  final List<String> teamNames;
  final List<String> userWords;
  final int targetWordCount;
  final String hostTeamName;

  const InitializeGameEvent({
    required List<String> teamNames,
    required List<String> userWords,
    required int targetWordCount,
    required String hostTeamName,
  })  : teamNames = teamNames,
        userWords = userWords,
        targetWordCount = targetWordCount,
        hostTeamName = hostTeamName;

  @override
  List<Object?> get props => <Object?>[
        teamNames,
        userWords,
        targetWordCount,
        hostTeamName,
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
