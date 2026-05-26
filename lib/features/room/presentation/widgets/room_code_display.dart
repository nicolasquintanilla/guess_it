import 'package:flutter/material.dart';

/// Widget de interfaz que muestra en grande el código de la sala de espera.
///
/// Diseñado para que el anfitrión pueda ver fácilmente el código y compartirlo
/// con otros jugadores en la misma habitación.
class RoomCodeDisplay extends StatelessWidget {
  /// El código identificador de 6 caracteres.
  final String roomId;

  /// Crea una instancia de [RoomCodeDisplay].
  ///
  /// @param key El identificador opcional para el widget.
  /// @param roomId El texto del código a renderizar.
  const RoomCodeDisplay({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  /// Construye la representación gráfica del código.
  ///
  /// @param context El contexto de construcción actual.
  /// @return Un [Widget] centrado con fuente grande y espaciada.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Código de la sala:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            roomId,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              letterSpacing: 8,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
