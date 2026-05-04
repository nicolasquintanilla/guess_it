import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/features/game/presentation/bloc/game_bloc.dart';
import 'package:guess_it/features/game/presentation/bloc/game_event.dart';

class CustomWordsPage extends StatefulWidget {
  final Map<String, dynamic> setupData;

  const CustomWordsPage({
    Key? key,
    required Map<String, dynamic> setupData,
  })  : setupData = setupData,
        super(key: key);

  @override
  State<CustomWordsPage> createState() {
    return _CustomWordsPageState();
  }
}

class _CustomWordsPageState extends State<CustomWordsPage> {
  final List<String> addedWords = <String>[];
  final TextEditingController wordController = TextEditingController();

  @override
  void dispose() {
    wordController.dispose();
    super.dispose();
  }

  void _addWord() {
    final String newWord = wordController.text.trim().toUpperCase();
    if (newWord.isNotEmpty && !addedWords.contains(newWord)) {
      setState(() {
        addedWords.add(newWord);
        wordController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int targetCount = widget.setupData['targetCount'] as int;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Palabras'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            Text(
              'Palabras: ${addedWords.length} / $targetCount',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: wordController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Nueva palabra',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (String _) {
                      _addWord();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.add, size: 32),
                  onPressed: _addWord,
                  color: Colors.blueAccent,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: addedWords.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(addedWords[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            addedWords.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<GameBloc>().add(
                      InitializeGameEvent(
                        teamOneName: widget.setupData['teamOne'] as String,
                        teamTwoName: widget.setupData['teamTwo'] as String,
                        userWords: addedWords,
                        targetWordCount: targetCount,
                      ),
                    );
                context.push('/play');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: const Text('¡Generar Partida y Jugar!'),
            ),
          ],
        ),
      ),
    );
  }
}
