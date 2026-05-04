import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class InitializeGameEvent extends GameEvent {
  final String teamOneName;
  final String teamTwoName;

  const InitializeGameEvent({
    required String teamOneName,
    required String teamTwoName,
  })  : teamOneName = teamOneName,
        teamTwoName = teamTwoName;

  @override
  List<Object?> get props => <Object?>[teamOneName, teamTwoName];
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
