import 'package:flutter/material.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';
import 'package:guess_it/core/widgets/rule_card.dart';

/// Pantalla estática que muestra las reglas y el funcionamiento del juego.
///
/// Este widget renderiza una lista de tarjetas informativas (`RuleCard`)
/// explicando las dinámicas de cada una de las 3 rondas (Tabú, Una Palabra, Mímica)
/// y las penalizaciones por pasar palabra.
class HowToPlayPage extends StatelessWidget {
  @override
  final Key? key;

  /// Crea una instancia de [HowToPlayPage].
  ///
  /// @param key El identificador opcional para el widget.
  const HowToPlayPage({Key? key}) : key = key;

  /// Construye la representación visual de la pantalla de instrucciones.
  ///
  /// @param context El contexto de construcción actual.
  /// @return Un [Widget] que renderiza las reglas utilizando [PremiumScaffold].
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
            const RuleCard(
              title: 'Ronda 1: Descripción Libre',
              icon: Icons.chat_bubble_outline,
              color: Colors.blueAccent,
              description:
                  'En esta primera ronda, el jugador que tiene el móvil debe describir la palabra a su equipo usando cualquier frase o pista.\n\n❌ Prohibido: No puedes decir partes de la palabra, no puedes traducirla a otro idioma y no puedes usar la táctica de "empieza por la letra...".',
            ),
            const SizedBox(height: 16),
            const RuleCard(
              title: 'Ronda 2: Solo Una Palabra',
              icon: Icons.looks_one,
              color: Colors.orangeAccent,
              description:
                  '¡Cuidado! Se usan las mismas palabras de la ronda anterior, pero ahora el jugador solo puede decir UNA única palabra como pista.\n\n❌ Prohibido: Hacer sonidos extra, gesticular o decir frases.',
            ),
            const SizedBox(height: 16),
            const RuleCard(
              title: 'Ronda 3: Mímica',
              icon: Icons.sports_martial_arts,
              color: Colors.pinkAccent,
              description:
                  'La prueba final. Con las mismas palabras, ahora debes hacer que tu equipo las adivine usando únicamente tu cuerpo.\n\n❌ Prohibido: Hablar, tararear, hacer efectos de sonido o señalar objetos de la habitación. ¡Solo mímica!',
            ),
            const SizedBox(height: 16),
            const RuleCard(
              title: '¡Regla de Oro para Pasar Palabra!',
              icon: Icons.warning_amber_rounded,
              color: Colors.redAccent,
              description:
                  'Solo puedes pasar una palabra si la acabas de leer y aún no has empezado a actuar. Si ya has empezado a hacer alguna acción y tu equipo se atasca... ¡No puedes pasarla! Tendréis que adivinarla obligatoriamente para poder avanzar a la siguiente.',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
