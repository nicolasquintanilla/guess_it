import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AiSettingsSection extends StatelessWidget {
  final bool isAiOpponent;
  final int aiDifficulty;
  final Function(bool) onAiToggle;
  final Function(int) onDifficultyChanged;

  const AiSettingsSection({
    Key? key,
    required this.isAiOpponent,
    required this.aiDifficulty,
    required this.onAiToggle,
    required this.onDifficultyChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SwitchListTile(
          title: const Text(
            '¿Jugar contra el Bot?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: const Text(
            'El Equipo 2 será controlado por Gessi',
            style: TextStyle(color: Colors.white70),
          ),
          value: isAiOpponent,
          activeColor: Colors.orangeAccent,
          onChanged: onAiToggle,
        ),
        if (isAiOpponent) ...<Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Dificultad de la Máquina',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: aiDifficulty,
                backgroundColor: Colors.black26,
                thumbColor: Colors.white,
                children: <int, Widget>{
                  0: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Fácil',
                      style: TextStyle(
                        color: aiDifficulty == 0
                            ? Colors.deepPurple
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  1: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Media',
                      style: TextStyle(
                        color: aiDifficulty == 1
                            ? Colors.deepPurple
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  2: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Difícil',
                      style: TextStyle(
                        color: aiDifficulty == 2
                            ? Colors.deepPurple
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                },
                onValueChanged: (int? value) {
                  if (value != null) {
                    onDifficultyChanged(value);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ],
    );
  }
}
