import 'package:flutter/material.dart';

/// Widget de interfaz que proporciona un campo de texto especializado para introducir el código de sala.
///
/// Convierte automáticamente el texto a mayúsculas, centra el contenido y aplica
/// un estilo espaciado para facilitar la lectura del código (ej. "ABC123").
class RoomCodeInput extends StatelessWidget {
  /// Controlador asociado al campo de texto para recuperar el valor introducido.
  final TextEditingController controller;

  /// Crea una instancia de [RoomCodeInput].
  ///
  /// @param key El identificador opcional para el widget.
  /// @param controller El controlador inyectado que manejará el texto.
  const RoomCodeInput({
    Key? key,
    required this.controller,
  }) : super(key: key);

  /// Construye la representación gráfica del campo de entrada.
  ///
  /// @param context El contexto de construcción actual.
  /// @return Un [Widget] de tipo `TextField` con estilo destacado.
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.characters,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        letterSpacing: 4,
        color: Colors.white,
      ),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'CÓDIGO',
        hintStyle: TextStyle(color: Colors.white54),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}
