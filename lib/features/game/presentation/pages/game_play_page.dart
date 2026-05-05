import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/features/game/domain/entities/game_entity.dart';
import 'package:guess_it/features/game/presentation/bloc/game_bloc.dart';
import 'package:guess_it/features/game/presentation/bloc/game_event.dart';
import 'package:guess_it/features/game/presentation/bloc/game_state.dart';

class GamePlayPage extends StatelessWidget {
  const GamePlayPage({Key? key}) : super(key: key);

  String _getRoundRulesText(int round) {
    switch (round) {
      case 1:
        return 'Ronda 1: Descripción - Puedes usar cualquier frase';
      case 2:
        return 'Ronda 2: Una Palabra - Solo puedes decir una única pista';
      case 3:
        return 'Ronda 3: Mímica - Prohibido hablar, solo gestos y sonidos';
      default:
        return 'Ronda Desconocida';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameState>(
      listener: (BuildContext context, GameState state) {
        if (state.status == GameStatus.finished) {
          context.go('/scoreboard');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<GameBloc, GameState>(
            builder: (BuildContext context, GameState state) {
              final GameEntity? game = state.game;
              if (game == null) {
                return const Text('Cargando...');
              }
              final String activeTeamName =
                  game.activeTeam == 1 ? game.teamOneName : game.teamTwoName;
              return Text('Turno de: $activeTeamName');
            },
          ),
        ),
        body: BlocBuilder<GameBloc, GameState>(
          builder: (BuildContext context, GameState state) {
            final GameEntity? game = state.game;
            if (game == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final String activeTeamName =
                game.activeTeam == 1 ? game.teamOneName : game.teamTwoName;
            final int activeTeamScore =
                game.activeTeam == 1 ? game.teamOneScore : game.teamTwoScore;

            if (state.remainingSeconds == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Puntos de $activeTeamName: $activeTeamScore',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        _getRoundRulesText(game.currentRound),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () {
                        context.read<GameBloc>().add(const StartTurnEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Empezar Turno'),
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${state.remainingSeconds}',
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    state.currentWord,
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      OutlinedButton(
                        onPressed: () {
                          context.read<GameBloc>().add(const SkipWordEvent());
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                          side: const BorderSide(color: Colors.red, width: 2),
                        ),
                        child: const Text(
                          'Pasar',
                          style: TextStyle(color: Colors.red, fontSize: 24),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<GameBloc>().add(const CorrectAnswerEvent());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                        ),
                        child: const Text(
                          '¡Correcto!',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
