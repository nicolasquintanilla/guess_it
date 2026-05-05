import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_it/features/game/presentation/bloc/game_event.dart';
import 'package:guess_it/features/game/presentation/bloc/game_state.dart';
import 'package:guess_it/features/game/domain/entities/game_entity.dart';
import 'package:guess_it/features/game/domain/repositories/word_repository.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final WordRepository wordRepository;
  Timer? _turnTimer;

  GameBloc({
    required WordRepository wordRepository,
  })  : wordRepository = wordRepository,
        super(GameState.initial()) {
    on<InitializeGameEvent>(_onInitializeGame);
    on<AddPointsEvent>(_onAddPoints);
    on<SwitchTurnEvent>(_onSwitchTurn);
    on<EndGameEvent>(_onEndGame);
    on<StartTurnEvent>(_onStartTurn);
    on<TickTimerEvent>(_onTickTimer);
    on<CorrectAnswerEvent>(_onCorrectAnswer);
    on<SkipWordEvent>(_onSkipWord);
  }

  @override
  Future<void> close() {
    _turnTimer?.cancel();
    return super.close();
  }

  void _onInitializeGame(
    InitializeGameEvent event,
    Emitter<GameState> emit,
  ) {
    final GameEntity newGame = GameEntity(
      teamOneName: event.teamOneName,
      teamTwoName: event.teamTwoName,
      teamOneScore: 0,
      teamTwoScore: 0,
      currentRound: 1,
      activeTeam: 1,
      gameStatus: 'in_progress',
    );

    final List<String> generatedBag = wordRepository.generateWordBag(
      event.userWords,
      event.targetWordCount,
    );

    emit(state.copyWith(
      status: GameStatus.playing,
      game: newGame,
      remainingSeconds: 0,
      currentWord: '',
      currentBag: List<String>.from(generatedBag),
      masterBag: List<String>.from(generatedBag),
    ));
  }

  void _onAddPoints(
    AddPointsEvent event,
    Emitter<GameState> emit,
  ) {
    if (state.game == null) {
      return;
    }

    final GameEntity currentGame = state.game!;
    GameEntity updatedGame;

    if (currentGame.activeTeam == 1) {
      updatedGame = currentGame.copyWith(
        teamOneScore: currentGame.teamOneScore + event.points,
      );
    } else {
      updatedGame = currentGame.copyWith(
        teamTwoScore: currentGame.teamTwoScore + event.points,
      );
    }

    emit(state.copyWith(game: updatedGame));
  }

  void _onSwitchTurn(
    SwitchTurnEvent event,
    Emitter<GameState> emit,
  ) {
    _turnTimer?.cancel();

    if (state.game == null) {
      return;
    }

    final GameEntity currentGame = state.game!;
    GameEntity updatedGame;

    if (currentGame.activeTeam == 1) {
      updatedGame = currentGame.copyWith(
        activeTeam: 2,
      );
    } else {
      updatedGame = currentGame.copyWith(
        activeTeam: 1,
      );
    }

    // Si la palabra actual no se acertó, la devolvemos a la bolsa al cambiar de turno
    final List<String> newBag = List<String>.from(state.currentBag);
    if (state.currentWord.isNotEmpty) {
      newBag.add(state.currentWord);
    }

    emit(state.copyWith(
      game: updatedGame,
      remainingSeconds: 0,
      currentWord: '',
      currentBag: newBag,
    ));
  }

  void _onEndGame(
    EndGameEvent event,
    Emitter<GameState> emit,
  ) {
    _turnTimer?.cancel();
    if (state.game == null) {
      return;
    }

    final GameEntity updatedGame = state.game!.copyWith(
      gameStatus: 'finished',
    );

    emit(state.copyWith(
      status: GameStatus.finished,
      game: updatedGame,
    ));
  }

  void _onStartTurn(
    StartTurnEvent event,
    Emitter<GameState> emit,
  ) {
    _turnTimer?.cancel();
    
    if (state.currentBag.isEmpty) {
      // No hay palabras para jugar
      return;
    }

    final List<String> newBag = List<String>.from(state.currentBag);
    final String newWord = newBag.removeAt(0);
    
    emit(state.copyWith(
      remainingSeconds: 30,
      currentWord: newWord,
      currentBag: newBag,
    ));

    _turnTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      add(const TickTimerEvent());
    });
  }

  void _onTickTimer(
    TickTimerEvent event,
    Emitter<GameState> emit,
  ) {
    if (state.remainingSeconds > 0) {
      final int updatedSeconds = state.remainingSeconds - 1;
      emit(state.copyWith(remainingSeconds: updatedSeconds));
      if (updatedSeconds == 0) {
        _turnTimer?.cancel();
        add(const SwitchTurnEvent());
      }
    }
  }

  void _onCorrectAnswer(
    CorrectAnswerEvent event,
    Emitter<GameState> emit,
  ) {
    if (state.game == null || state.remainingSeconds == 0) {
      return;
    }

    final GameEntity currentGame = state.game!;
    GameEntity updatedGame;

    if (currentGame.activeTeam == 1) {
      updatedGame = currentGame.copyWith(
        teamOneScore: currentGame.teamOneScore + 1,
      );
    } else {
      updatedGame = currentGame.copyWith(
        teamTwoScore: currentGame.teamTwoScore + 1,
      );
    }

    final List<String> newBag = List<String>.from(state.currentBag);

    if (newBag.isEmpty) {
      _turnTimer?.cancel();
      
      if (currentGame.currentRound < 3) {
        updatedGame = currentGame.copyWith(
          currentRound: currentGame.currentRound + 1,
        );
        final List<String> reloadedBag = List<String>.from(state.masterBag)..shuffle();
        
        emit(state.copyWith(
          game: updatedGame,
          currentBag: reloadedBag,
          currentWord: '',
          remainingSeconds: 0,
        ));
      } else {
        updatedGame = currentGame.copyWith(
          gameStatus: 'finished',
        );
        emit(state.copyWith(
          status: GameStatus.finished,
          game: updatedGame,
          currentWord: '',
          remainingSeconds: 0,
        ));
      }
      return;
    }

    final String newWord = newBag.removeAt(0);

    emit(state.copyWith(
      game: updatedGame,
      currentWord: newWord,
      currentBag: newBag,
    ));
  }

  void _onSkipWord(
    SkipWordEvent event,
    Emitter<GameState> emit,
  ) {
    if (state.remainingSeconds == 0 || state.currentBag.isEmpty) {
      return;
    }

    final List<String> newBag = List<String>.from(state.currentBag);
    
    // Ponemos la palabra actual al final de la bolsa
    if (state.currentWord.isNotEmpty) {
      newBag.add(state.currentWord);
    }

    // Sacamos la nueva
    final String newWord = newBag.removeAt(0);

    emit(state.copyWith(
      currentWord: newWord,
      currentBag: newBag,
    ));
  }
}
