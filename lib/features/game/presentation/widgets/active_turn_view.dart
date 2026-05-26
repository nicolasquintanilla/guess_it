import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_it/features/game/domain/entities/team_entity.dart';
import 'package:guess_it/features/game/presentation/bloc/game_bloc.dart';
import 'package:guess_it/features/game/presentation/bloc/game_event.dart';
import 'package:guess_it/features/game/presentation/bloc/game_state.dart';

class ActiveTurnView extends StatelessWidget {
  final GameState state;
  final TeamEntity activeTeam;
  final int currentTurnScore;

  const ActiveTurnView({
    Key? key,
    required this.state,
    required this.activeTeam,
    required this.currentTurnScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: FittedBox(
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
          if (activeTeam.name.startsWith('Gessi'))
            const Column(
              children: <Widget>[
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Gessi está describiendo la palabra...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            )
          else
            IgnorePointer(
              ignoring: activeTeam.name.startsWith('Gessi'),
              child: Row(
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
            ),
          const SizedBox(height: 48),
        ],
      ],
    );
  }
}
