import 'package:flutter/material.dart';

class HowToPlayPage extends StatelessWidget {
  const HowToPlayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cómo Jugar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24.0, top: 24.0, right: 24.0, bottom: 88.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Objetivo',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 8),
            const Text(
              'Adivinar más palabras que el resto de equipos a lo largo de las 3 rondas del juego.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),
            _buildRoundCard(
              round: 'Ronda 1: Descripción',
              description: 'Explica la palabra usando cualquier frase, pero sin usar partes de la palabra a adivinar ni traducirla a otro idioma.',
              icon: Icons.chat_bubble_outline,
            ),
            const SizedBox(height: 16),
            _buildRoundCard(
              round: 'Ronda 2: Una Palabra',
              description: 'Di una sola palabra como pista. Prohibido hacer frases. Tu equipo tiene un único intento para adivinarla por cada pista.',
              icon: Icons.looks_one,
            ),
            const SizedBox(height: 16),
            _buildRoundCard(
              round: 'Ronda 3: Mímica',
              description: 'Prohibido hablar o hacer ruidos. Solo gestos. Podéis tararear si es una canción.',
              icon: Icons.sports_kabaddi,
            ),
            const SizedBox(height: 32),
            const Text(
              'Puntuación y Revisión',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 8),
            const Text(
              'Al acabar el tiempo (30 segundos), podréis revisar y corregir los aciertos y fallos antes de pasar el turno al siguiente equipo. El equipo que vaya perdiendo empezará las rondas siguientes.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundCard({required String round, required String description, required IconData icon}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, size: 40, color: Colors.deepPurple),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    round,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
