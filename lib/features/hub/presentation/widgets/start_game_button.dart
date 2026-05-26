import 'package:flutter/material.dart';

/// Widget reutilizable que representa el botón principal y destacado de la pantalla Hub.
///
/// Este botón utiliza un degradado atractivo y sombras para incentivar la
/// acción más importante de la aplicación: iniciar una nueva partida.
class StartGameButton extends StatelessWidget {
  /// Callback que se ejecuta al presionar el botón.
  final VoidCallback onStart;

  /// Crea una instancia de [StartGameButton].
  ///
  /// @param key El identificador opcional para el widget.
  /// @param onStart La función de acción principal para iniciar el juego.
  const StartGameButton({
    Key? key,
    required this.onStart,
  }) : super(key: key);

  /// Construye la representación visual del botón de inicio rápido.
  ///
  /// @param context El contexto de construcción actual.
  /// @return Un [Widget] con diseño resaltado e interactividad.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onStart,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            colors: <Color>[
              Colors.orangeAccent,
              Colors.pinkAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 24.0,
          ),
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.play_arrow_rounded,
                size: 60,
                color: Colors.white,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      'Empezar Partida',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
