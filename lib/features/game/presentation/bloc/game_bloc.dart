import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_it/features/game/presentation/bloc/game_event.dart';
import 'package:guess_it/features/game/presentation/bloc/game_state.dart';
import 'package:guess_it/features/game/domain/entities/game_entity.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameState.initial()) {
    on<InitializeGameEvent>(_onInitializeGame);
    on<AddPointsEvent>(_onAddPoints);
    on<SwitchTurnEvent>(_onSwitchTurn);
    on<EndGameEvent>(_onEndGame);
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

    emit(state.copyWith(
      status: GameStatus.playing,
      game: newGame,
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
        currentRound: currentGame.currentRound + 1,
      );
    }

    emit(state.copyWith(game: updatedGame));
  }

  void _onEndGame(
    EndGameEvent event,
    Emitter<GameState> emit,
  ) {
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
}
