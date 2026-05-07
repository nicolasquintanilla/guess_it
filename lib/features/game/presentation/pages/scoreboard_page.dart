import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/features/game/domain/entities/game_entity.dart';
import 'package:guess_it/features/game/domain/entities/team_entity.dart';
import 'package:guess_it/features/game/presentation/bloc/game_bloc.dart';
import 'package:guess_it/features/game/presentation/bloc/game_state.dart';
import 'package:guess_it/features/ranking/presentation/bloc/ranking_bloc.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';

class ScoreboardPage extends StatefulWidget {
  @override
  final Key? key;

  const ScoreboardPage({Key? key}) : key = key;

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

    if (game != null && game.teams.isNotEmpty) {
      final TeamEntity hostTeam = game.teams.firstWhere(
        (TeamEntity team) => team.name == game.hostTeamName,
        orElse: () => game.teams.first,
      );

      final int maxScore = game.teams.fold(
        0,
        (int currentMax, TeamEntity team) => team.score > currentMax ? team.score : currentMax,
      );

      final bool isVictory = hostTeam.score == maxScore;

      context.read<RankingBloc>().add(
        SubmitWinEvent(
          points: hostTeam.score,
          isVictory: isVictory,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: 'Resultados',
      showBackArrow: false,
      child: BlocBuilder<GameBloc, GameState>(
        builder: (BuildContext context, GameState state) {
          final GameEntity? game = state.game;
          
          if (game == null || game.teams.isEmpty) {
            return const Center(child: Text('Error cargando resultados.', style: TextStyle(color: Colors.white)));
          }

          final List<TeamEntity> sortedTeams = List<TeamEntity>.from(game.teams)
            ..sort((TeamEntity a, TeamEntity b) => b.score.compareTo(a.score));

          final TeamEntity winner = sortedTeams.first;

          final bool isTie = sortedTeams.length > 1 && sortedTeams[0].score == sortedTeams[1].score;
          final String resultText = isTie ? '¡Empate en cabeza!' : '¡Gana el equipo ${winner.name}!';

          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 32),
                  const Icon(
                    Icons.emoji_events,
                    size: 150,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    resultText,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sortedTeams.length,
                    itemBuilder: (BuildContext context, int index) {
                      final TeamEntity team = sortedTeams[index];
                      final bool isWinner = index == 0 && !isTie;
                      final bool isTiedWinner = isTie && team.score == winner.score;
                      
                      return ListTile(
                        leading: (isWinner || isTiedWinner)
                            ? const Icon(Icons.star, color: Colors.amber, size: 32)
                            : Text(
                                '#${index + 1}', 
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                        title: Text(
                          team.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: (isWinner || isTiedWinner) ? FontWeight.bold : FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                        trailing: Text(
                          '${team.score} pts',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 48.0, bottom: 32.0, left: 16.0, right: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/hub');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepPurple,
                      ),
                      child: const Text('Volver al Hub'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
