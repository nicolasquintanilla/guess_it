import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/features/game/domain/entities/game_entity.dart';
import 'package:guess_it/features/game/domain/entities/team_entity.dart';
import 'package:guess_it/features/game/presentation/bloc/game_bloc.dart';
import 'package:guess_it/features/game/presentation/bloc/game_event.dart';
import 'package:guess_it/features/game/presentation/bloc/game_state.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';

class GamePlayPage extends StatelessWidget {
  @override
  final Key? key;

  const GamePlayPage({Key? key}) : key = key;

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
                      final TeamEntity activeTeam =
                          game.teams[game.activeTeamIndex];
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
                                  final bool isGuessed = state.turnGuessedWords
                                      .contains(word);

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
                                                // Bloqueado para la IA
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

                    final TeamEntity activeTeam =
                        game.teams[game.activeTeamIndex];
                    final int currentTurnScore = state.turnGuessedWords.length;

                    if (state.remainingSeconds == 0) {
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: game.teams.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                            final TeamEntity team =
                                                game.teams[index];
                                            final bool isActive =
                                                index == game.activeTeamIndex;
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 4.0,
                                                  ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    team.name,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: isActive
                                                          ? FontWeight.w900
                                                          : FontWeight.w500,
                                                      color: isActive
                                                          ? Colors
                                                                .deepPurpleAccent
                                                          : Colors.black87,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${team.score} pts',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: isActive
                                                          ? FontWeight.w900
                                                          : FontWeight.w500,
                                                      color: isActive
                                                          ? Colors
                                                                .deepPurpleAccent
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

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Puntos: ${activeTeam.score} (+$currentTurnScore)',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '${state.remainingSeconds}',
                          style: const TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        if (state.status == GameStatus.paused) ...<Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'JUEGO PAUSADO',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const Spacer(),
                        ] else ...<Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32.0,
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(48.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  state.currentWord,
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (activeTeam.name == 'IA Guess It')
                            const Column(
                              children: <Widget>[
                                CircularProgressIndicator(color: Colors.white),
                                SizedBox(height: 16),
                                Text(
                                  'La IA está describiendo la palabra...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            )
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    HapticFeedback.heavyImpact();
                                    context.read<GameBloc>().add(
                                      const SkipWordEvent(),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 24,
                                    ),
                                  ),
                                  child: const Text(
                                    'Pasar',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    Future<void>.delayed(
                                      const Duration(milliseconds: 100),
                                      () {
                                        HapticFeedback.lightImpact();
                                      },
                                    );
                                    context.read<GameBloc>().add(
                                      const CorrectAnswerEvent(),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 24,
                                    ),
                                  ),
                                  child: const Text(
                                    '¡Correcto!',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 48),
                        ],
                      ],
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
