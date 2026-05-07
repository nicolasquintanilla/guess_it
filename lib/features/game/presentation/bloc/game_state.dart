import 'package:equatable/equatable.dart';
import 'package:guess_it/features/game/domain/entities/game_entity.dart';

enum GameStatus { initial, loading, playing, paused, turnReview, finished }

class GameState extends Equatable {
  final GameStatus status;
  final GameEntity? game;
  final int remainingSeconds;
  final String currentWord;
  final List<String> currentBag;
  final List<String> masterBag;
  final List<String> turnGuessedWords;
  final List<String> turnSkippedWords;

  const GameState({
    required GameStatus status,
    required GameEntity? game,
    required int remainingSeconds,
    required String currentWord,
    required List<String> currentBag,
    required List<String> masterBag,
    required List<String> turnGuessedWords,
    required List<String> turnSkippedWords,
  })  : status = status,
        game = game,
        remainingSeconds = remainingSeconds,
        currentWord = currentWord,
        currentBag = currentBag,
        masterBag = masterBag,
        turnGuessedWords = turnGuessedWords,
        turnSkippedWords = turnSkippedWords;

  factory GameState.initial() {
    return const GameState(
      status: GameStatus.initial,
      game: null,
      remainingSeconds: 0,
      currentWord: '',
      currentBag: <String>[],
      masterBag: <String>[],
      turnGuessedWords: <String>[],
      turnSkippedWords: <String>[],
    );
  }

  GameState copyWith({
    GameStatus? status,
    GameEntity? game,
    int? remainingSeconds,
    String? currentWord,
    List<String>? currentBag,
    List<String>? masterBag,
    List<String>? turnGuessedWords,
    List<String>? turnSkippedWords,
  }) {
    return GameState(
      status: status ?? this.status,
      game: game ?? this.game,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      currentWord: currentWord ?? this.currentWord,
      currentBag: currentBag ?? this.currentBag,
      masterBag: masterBag ?? this.masterBag,
      turnGuessedWords: turnGuessedWords ?? this.turnGuessedWords,
      turnSkippedWords: turnSkippedWords ?? this.turnSkippedWords,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        game,
        remainingSeconds,
        currentWord,
        currentBag,
        masterBag,
        turnGuessedWords,
        turnSkippedWords,
      ];
}
