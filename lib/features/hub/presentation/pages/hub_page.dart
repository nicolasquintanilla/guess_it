import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HubPage extends StatelessWidget {
  const HubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guess It!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                context.push('/game-setup');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              child: const Text('Nueva Partida Local'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.push('/ranking');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                backgroundColor: Colors.amber,
              ),
              child: const Text('🏆 Ver Clasificación Mundial'),
            ),
          ],
        ),
      ),
    );
  }
}
