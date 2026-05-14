import 'package:flutter/material.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';

class HowToPlayPage extends StatelessWidget {
  @override
  final Key? key;

  const HowToPlayPage({Key? key}) : key = key;

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: 'Cómo Jugar',
      showBackArrow: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Objetivo del Juego',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Guess It! es un juego por equipos donde tendréis que adivinar tantas palabras como sea posible antes de que se acabe el tiempo. El juego consta de 3 rondas y se juega con la misma bolsa de palabras en todas ellas. ¡La memoria es clave!',
              style: TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
            ),
            const SizedBox(height: 32),
            const _RuleCard(
              title: 'Ronda 1: Descripción Libre',
              icon: Icons.chat_bubble_outline,
              color: Colors.blueAccent,
              description:
                  'En esta primera ronda, el jugador que tiene el móvil debe describir la palabra a su equipo usando cualquier frase o pista.\n\n❌ Prohibido: No puedes decir partes de la palabra, no puedes traducirla a otro idioma y no puedes usar la táctica de "empieza por la letra...".',
            ),
            const SizedBox(height: 16),
            const _RuleCard(
              title: 'Ronda 2: Solo Una Palabra',
              icon: Icons.looks_one,
              color: Colors.orangeAccent,
              description:
                  '¡Cuidado! Se usan las mismas palabras de la ronda anterior, pero ahora el jugador solo puede decir UNA única palabra como pista.\n\n❌ Prohibido: Hacer sonidos extra, gesticular o decir frases.',
            ),
            const SizedBox(height: 16),
            const _RuleCard(
              title: 'Ronda 3: Mímica',
              icon: Icons.sports_martial_arts,
              color: Colors.pinkAccent,
              description:
                  'La prueba final. Con las mismas palabras, ahora debes hacer que tu equipo las adivine usando únicamente tu cuerpo.\n\n❌ Prohibido: Hablar, tararear, hacer efectos de sonido o señalar objetos de la habitación. ¡Solo mímica!',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _RuleCard extends StatelessWidget {
  @override
  final Key? key;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _RuleCard({
    Key? key,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) : key = key,
       title = title,
       description = description,
       icon = icon,
       color = color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
