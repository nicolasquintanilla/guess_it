import 'package:equatable/equatable.dart';
import 'package:guess_it/features/game/domain/entities/game_entity.dart';

enum GameStatus { initial, playing, finished }

class GameState extends Equatable {
  final GameStatus status;
  final GameEntity? game;
  final int remainingSeconds;
  final String currentWord;
  final List<String> currentBag;

  const GameState({
    required GameStatus status,
    required GameEntity? game,
    required int remainingSeconds,
    required String currentWord,
    required List<String> currentBag,
  })  : status = status,
        game = game,
        remainingSeconds = remainingSeconds,
        currentWord = currentWord,
        currentBag = currentBag;

  factory GameState.initial() {
    return const GameState(
      status: GameStatus.initial,
      game: null,
      remainingSeconds: 0,
      currentWord: '',
      currentBag: <String>[],
    );
  }

  GameState copyWith({
    GameStatus? status,
    GameEntity? game,
    int? remainingSeconds,
    String? currentWord,
    List<String>? currentBag,
  }) {
    return GameState(
      status: status ?? this.status,
      game: game ?? this.game,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      currentWord: currentWord ?? this.currentWord,
      currentBag: currentBag ?? this.currentBag,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        game,
        remainingSeconds,
        currentWord,
        currentBag,
      ];
}
