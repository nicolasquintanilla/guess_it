import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_it/features/game/domain/entities/game_entity.dart';
import 'package:guess_it/features/game/domain/entities/team_entity.dart';
import 'package:guess_it/features/game/presentation/bloc/game_bloc.dart';
import 'package:guess_it/features/game/presentation/bloc/game_event.dart';
import 'package:guess_it/features/game/presentation/bloc/game_state.dart';

class TurnReviewView extends StatelessWidget {
  final GameState state;
  final GameEntity game;

  const TurnReviewView({
    Key? key,
    required this.state,
    required this.game,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TeamEntity activeTeam = game.teams[game.activeTeamIndex];
    final bool isAi = activeTeam.name.startsWith('Gessi');

    final List<String> allPlayedWords = <String>[
      ...state.turnGuessedWords,
      ...state.turnSkippedWords,
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 16),
          const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '¡Tiempo! Revisión de Palabras',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: allPlayedWords.length,
              itemBuilder: (BuildContext context, int index) {
                final String word = allPlayedWords[index];
                final bool isGuessed = state.turnGuessedWords.contains(word);

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: ListTile(
                    title: Text(
                      word,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: CupertinoSwitch(
                      value: isGuessed,
                      activeColor: Colors.green,
                      onChanged: isAi
                          ? null
                          : (bool newValue) {
                              // Bloqueado para el bot
                              context.read<GameBloc>().add(
                                ToggleWordReviewEvent(
                                  word: word,
                                  wasGuessed: newValue,
                                ),
                              );
                            },
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<GameBloc>().add(
                  const SwitchTurnEvent(),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 24,
                ),
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
              ),
              child: const Text('Confirmar'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
