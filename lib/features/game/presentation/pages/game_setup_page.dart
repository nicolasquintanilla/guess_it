import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/features/game/presentation/bloc/game_bloc.dart';
import 'package:guess_it/features/game/presentation/bloc/game_event.dart';

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

  @override
  void dispose() {
    teamOneController.dispose();
    teamTwoController.dispose();
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
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                final String t1 = teamOneController.text.trim();
                final String t2 = teamTwoController.text.trim();
                if (t1.isEmpty || t2.isEmpty) {
                  return;
                }
                context.read<GameBloc>().add(
                      InitializeGameEvent(
                        teamOneName: t1,
                        teamTwoName: t2,
                      ),
                    );
                context.push('/play');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: const Text('¡A Jugar!'),
            ),
          ],
        ),
      ),
    );
  }
}
