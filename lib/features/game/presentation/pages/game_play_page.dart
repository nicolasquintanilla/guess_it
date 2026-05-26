import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/features/game/domain/entities/game_entity.dart';
import 'package:guess_it/features/game/domain/entities/team_entity.dart';
import 'package:guess_it/features/game/presentation/bloc/game_bloc.dart';
import 'package:guess_it/features/game/presentation/bloc/game_event.dart';
import 'package:guess_it/features/game/presentation/bloc/game_state.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';
import 'package:guess_it/features/game/presentation/widgets/turn_review_view.dart';
import 'package:guess_it/features/game/presentation/widgets/pre_turn_standby_view.dart';
import 'package:guess_it/features/game/presentation/widgets/active_turn_view.dart';

class GamePlayPage extends StatelessWidget {
  @override
  final Key? key;

  const GamePlayPage({Key? key}) : key = key;

  void _showExitConfirmation(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: const Text('¿Terminar Partida?'),
          content: const Text(
            'Si sales ahora, todo el progreso de esta partida se perderá.',
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Salir'),
              onPressed: () {
                Navigator.of(ctx).pop();
                context.read<GameBloc>().add(const ResetGameEvent());
                context.go('/hub');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameState>(
      listener: (BuildContext context, GameState state) {
        if (state.status == GameStatus.finished) {
          context.go('/scoreboard');
        }
      },
      child: BlocBuilder<GameBloc, GameState>(
        builder: (BuildContext context, GameState state) {
          String titleText = 'Cargando...';
          if (state.status == GameStatus.loading) {
            titleText = 'Generando Bolsa...';
          } else if (state.game != null) {
            final TeamEntity activeTeam =
                state.game!.teams[state.game!.activeTeamIndex];
            titleText = 'Turno de: ${activeTeam.name}';
          }

          final List<Widget> actions = <Widget>[
            IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
              tooltip: 'Terminar partida',
              onPressed: () => _showExitConfirmation(context),
            ),
          ];

          if (state.remainingSeconds > 0 &&
              state.status != GameStatus.turnReview) {
            final bool isPaused = state.status == GameStatus.paused;
            actions.insert(
              0,
              IconButton(
                icon: Icon(
                  isPaused ? Icons.play_arrow : Icons.pause,
                  color: Colors.white,
                ),
                iconSize: 32,
                onPressed: () {
                  if (isPaused) {
                    context.read<GameBloc>().add(const ResumeGameEvent());
                  } else {
                    context.read<GameBloc>().add(const PauseGameEvent());
                  }
                },
              ),
            );
          }

          return PremiumScaffold(
            title: titleText,
            showBackArrow: false,
            actions: actions,
            child: PopScope(
              canPop: false,
              child: Center(
                child: Builder(
                  builder: (BuildContext context) {
                    if (state.status == GameStatus.loading ||
                        state.game == null) {
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      );
                    }

                    final GameEntity game = state.game!;

                    if (state.status == GameStatus.turnReview) {
                      return TurnReviewView(
                        state: state,
                        game: game,
                      );
                    }

                    final TeamEntity activeTeam =
                        game.teams[game.activeTeamIndex];
                    final int currentTurnScore = state.turnGuessedWords.length;

                    if (state.remainingSeconds == 0) {
                      return PreTurnStandbyView(game: game);
                    }

                    return ActiveTurnView(
                      state: state,
                      activeTeam: activeTeam,
                      currentTurnScore: currentTurnScore,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
