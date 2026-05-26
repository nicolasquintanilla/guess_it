import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_it/features/game/domain/entities/game_entity.dart';
import 'package:guess_it/features/game/domain/entities/team_entity.dart';
import 'package:guess_it/features/game/presentation/bloc/game_bloc.dart';
import 'package:guess_it/features/game/presentation/bloc/game_event.dart';

class PreTurnStandbyView extends StatelessWidget {
  final GameEntity game;

  const PreTurnStandbyView({
    Key? key,
    required this.game,
  }) : super(key: key);

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

  void _showRulesDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: const Text('Reglas de las Rondas'),
          content: const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '• Ronda 1 (Descripción): Explica usando cualquier frase. Prohibido usar partes de la palabra o idiomas.',
                ),
                SizedBox(height: 8),
                Text(
                  '• Ronda 2 (Una Palabra): Di solo una palabra como pista. Un intento por palabra.',
                ),
                SizedBox(height: 8),
                Text(
                  '• Ronda 3 (Mímica): Prohibido hablar o hacer ruidos. Solo gestos o tararear.',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Entendido'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Text(
              _getRoundRulesText(game.currentRound),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _showRulesDialog(context),
            icon: const Icon(
              Icons.menu_book,
              color: Colors.white,
            ),
            label: const Text(
              'Repasar Reglas',
              style: TextStyle(color: Colors.white),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
            ),
          ),
          const SizedBox(height: 32),
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 32.0,
            ),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Clasificación Actual',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: game.teams.length,
                    itemBuilder: (BuildContext context, int index) {
                      final TeamEntity team = game.teams[index];
                      final bool isActive = index == game.activeTeamIndex;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                team.name,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isActive
                                      ? FontWeight.w900
                                      : FontWeight.w500,
                                  color: isActive
                                      ? Colors.deepPurpleAccent
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${team.score} pts',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: isActive
                                    ? FontWeight.w900
                                    : FontWeight.w500,
                                color: isActive
                                    ? Colors.deepPurpleAccent
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {
              context.read<GameBloc>().add(
                const StartTurnEvent(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepPurple,
              elevation: 8,
              padding: const EdgeInsets.symmetric(
                horizontal: 48,
                vertical: 24,
              ),
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Empezar Turno'),
          ),
        ],
      ),
    );
  }
}
