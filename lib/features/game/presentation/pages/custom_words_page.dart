import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/features/game/presentation/bloc/game_bloc.dart';
import 'package:guess_it/features/game/presentation/bloc/game_event.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';
import 'package:guess_it/features/game/domain/entities/team_entity.dart';
import 'package:guess_it/features/game/presentation/widgets/word_input_row.dart';
import 'package:guess_it/features/game/presentation/widgets/word_list_item_card.dart';

class CustomWordsPage extends StatefulWidget {
  final List<TeamEntity> initialTeams;
  final int targetCount;
  final String hostTeamName;
  final int turnDurationSeconds;
  final String? groupId;

  @override
  final Key? key;

  const CustomWordsPage({
    Key? key,
    required List<TeamEntity> initialTeams,
    required int targetCount,
    required String hostTeamName,
    required int turnDurationSeconds,
    String? groupId,
  }) : key = key,
       initialTeams = initialTeams,
       targetCount = targetCount,
       hostTeamName = hostTeamName,
       turnDurationSeconds = turnDurationSeconds,
       groupId = groupId;

  @override
  State<CustomWordsPage> createState() {
    return _CustomWordsPageState();
  }
}

class _CustomWordsPageState extends State<CustomWordsPage> {
  final List<String> addedWords = <String>[];
  final List<bool> _obscureWords = <bool>[];
  final TextEditingController wordController = TextEditingController();

  @override
  void dispose() {
    wordController.dispose();
    super.dispose();
  }

  void _addWord() {
    final String newWord = wordController.text.trim().toUpperCase();
    if (newWord.isEmpty) return;

    if (addedWords.contains(newWord)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Esta palabra ya ha sido añadida.'), backgroundColor: Colors.orange, duration: Duration(seconds: 2)),
      );
      return;
    }

    if (addedWords.length >= widget.targetCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ya has alcanzado el límite de palabras.'), backgroundColor: Colors.red, duration: Duration(seconds: 2)),
      );
      return;
    }

    setState(() {
      addedWords.add(newWord);
      _obscureWords.add(true);
      wordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: 'Añadir Palabras',
      showBackArrow: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Palabras: ${addedWords.length} / ${widget.targetCount}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                WordInputRow(
                  controller: wordController,
                  onAdd: _addWord,
                ),
                const SizedBox(height: 24),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: addedWords.length,
                  itemBuilder: (BuildContext context, int index) {
                    return WordListItemCard(
                      word: addedWords[index],
                      isObscured: _obscureWords[index],
                      onToggleVisibility: () {
                        setState(() {
                          _obscureWords[index] = !_obscureWords[index];
                        });
                      },
                      onDelete: () {
                        setState(() {
                          addedWords.removeAt(index);
                          _obscureWords.removeAt(index);
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<GameBloc>().add(
                        InitializeGameEvent(
                          initialTeams: widget.initialTeams,
                          userWords: addedWords,
                          targetWordCount: widget.targetCount,
                          hostTeamName: widget.hostTeamName,
                          turnDurationSeconds: widget.turnDurationSeconds,
                          groupId: widget.groupId,
                        ),
                      );
                      context.push('/play');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 24,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Generar Partida'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
