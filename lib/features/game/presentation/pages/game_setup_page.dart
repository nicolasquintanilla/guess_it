import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameSetupPage extends StatefulWidget {
  const GameSetupPage({Key? key}) : super(key: key);

  @override
  State<GameSetupPage> createState() {
    return _GameSetupPageState();
  }
}

class _GameSetupPageState extends State<GameSetupPage> {
  final TextEditingController teamOneController = TextEditingController();
  final TextEditingController teamTwoController = TextEditingController();
  final TextEditingController countController = TextEditingController();

  @override
  void dispose() {
    teamOneController.dispose();
    teamTwoController.dispose();
    countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Partida'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: teamOneController,
              decoration: const InputDecoration(
                labelText: 'Nombre Equipo 1',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: teamTwoController,
              decoration: const InputDecoration(
                labelText: 'Nombre Equipo 2',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: countController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cantidad total de palabras',
                hintText: 'Ej. 30, 40, 60',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                final String t1 = teamOneController.text.trim();
                final String t2 = teamTwoController.text.trim();
                final String countStr = countController.text.trim();
                
                if (t1.isEmpty || t2.isEmpty || countStr.isEmpty) {
                  return;
                }
                
                final int? targetCount = int.tryParse(countStr);
                if (targetCount == null || targetCount <= 0) {
                  return;
                }

                context.push(
                  '/custom-words',
                  extra: <String, dynamic>{
                    'teamOne': t1,
                    'teamTwo': t2,
                    'targetCount': targetCount,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: const Text('Siguiente'),
            ),
          ],
        ),
      ),
    );
  }
}
