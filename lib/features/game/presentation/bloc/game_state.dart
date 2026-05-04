import 'package:equatable/equatable.dart';
import 'package:guess_it/features/game/domain/entities/game_entity.dart';

enum GameStatus { initial, playing, finished }

class GameState extends Equatable {
  final GameStatus status;
  final GameEntity? game;

  const GameState({
    required GameStatus status,
    required GameEntity? game,
  })  : status = status,
        game = game;

  factory GameState.initial() {
    return const GameState(
      status: GameStatus.initial,
      game: null,
    );
  }

  GameState copyWith({
    GameStatus? status,
    GameEntity? game,
  }) {
    return GameState(
      status: status ?? this.status,
      game: game ?? this.game,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, game];
}
