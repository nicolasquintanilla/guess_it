import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class InitializeGameEvent extends GameEvent {
  final String teamOneName;
  final String teamTwoName;
  final List<String> userWords;
  final int targetWordCount;
  final int hostTeam;

  const InitializeGameEvent({
    required String teamOneName,
    required String teamTwoName,
    required List<String> userWords,
    required int targetWordCount,
    required int hostTeam,
  })  : teamOneName = teamOneName,
        teamTwoName = teamTwoName,
        userWords = userWords,
        targetWordCount = targetWordCount,
        hostTeam = hostTeam;

  @override
  List<Object?> get props => <Object?>[
        teamOneName,
        teamTwoName,
        userWords,
        targetWordCount,
        hostTeam,
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
