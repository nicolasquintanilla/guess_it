import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/features/game/domain/entities/game_entity.dart';
import 'package:guess_it/features/game/presentation/bloc/game_bloc.dart';
import 'package:guess_it/features/game/presentation/bloc/game_state.dart';
import 'package:guess_it/features/ranking/presentation/bloc/ranking_bloc.dart';

class ScoreboardPage extends StatefulWidget {
  const ScoreboardPage({Key? key}) : super(key: key);

  @override
  State<ScoreboardPage> createState() {
    return _ScoreboardPageState();
  }
}

class _ScoreboardPageState extends State<ScoreboardPage> {
  @override
  void initState() {
    super.initState();
    _evaluateCompetitiveMode();
  }

  void _evaluateCompetitiveMode() {
    final GameBloc gameBloc = context.read<GameBloc>();
    final GameEntity? game = gameBloc.state.game;

    if (game != null) {
      final int scoreOne = game.teamOneScore;
      final int scoreTwo = game.teamTwoScore;
      final int hostTeam = game.hostTeam;

      if (scoreOne > scoreTwo && hostTeam == 1) {
        context.read<RankingBloc>().add(SubmitWinEvent(points: scoreOne));
      } else if (scoreTwo > scoreOne && hostTeam == 2) {
        context.read<RankingBloc>().add(SubmitWinEvent(points: scoreTwo));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados Finales'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<GameBloc, GameState>(
        builder: (BuildContext context, GameState state) {
          final GameEntity? game = state.game;
          
          if (game == null) {
            return const Center(child: Text('Error cargando resultados.'));
          }

          final String teamOne = game.teamOneName;
          final String teamTwo = game.teamTwoName;
          final int scoreOne = game.teamOneScore;
          final int scoreTwo = game.teamTwoScore;

          String resultText;
          if (scoreOne > scoreTwo) {
            resultText = '¡Gana el equipo $teamOne!';
          } else if (scoreTwo > scoreOne) {
            resultText = '¡Gana el equipo $teamTwo!';
          } else {
            resultText = '¡Empate!';
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.emoji_events,
                  size: 150,
                  color: Colors.amber,
                ),
                const SizedBox(height: 48),
                Text(
                  resultText,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                Text(
                  '$teamOne: $scoreOne puntos',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  '$teamTwo: $scoreTwo puntos',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    context.go('/hub');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                    textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Volver al Hub'),
                ),
                const SizedBox(height: 64),
              ],
            ),
          );
        },
      ),
    );
  }
}
