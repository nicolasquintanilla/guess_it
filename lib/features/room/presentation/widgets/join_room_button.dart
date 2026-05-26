import 'package:flutter/material.dart';

/// Botón estilizado específicamente diseñado para confirmar la unión a una sala.
///
/// Utiliza un estilo redondeado y colores consistentes con la temática de la app
/// (blanco sobre morado) para destacar la acción principal (Call to Action).
class JoinRoomButton extends StatelessWidget {
  /// Callback ejecutado cuando el usuario presiona el botón.
  final VoidCallback onPressed;

  /// Crea una instancia de [JoinRoomButton].
  ///
  /// @param key El identificador opcional para el widget.
  /// @param onPressed Función de acción al hacer tap.
  const JoinRoomButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  /// Construye la representación gráfica del botón.
  ///
  /// @param context El contexto de construcción actual.
  /// @return Un [Widget] de tipo `ElevatedButton` con el estilo aplicado.
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      child: const Text('Unirse'),
    );
  }
}
