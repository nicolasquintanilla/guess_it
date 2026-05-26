import 'package:flutter/material.dart';

/// Widget reutilizable en forma de tarjeta para mostrar una estadística individual.
///
/// Se utiliza en el perfil del usuario para mostrar datos numéricos como
/// el total de partidas jugadas o las victorias, acompañados de un icono temático.
class StatCard extends StatelessWidget {
  /// Icono representativo de la estadística (ej. trofeo, mando de juego).
  final IconData icon;

  /// Color de acento aplicado al icono.
  final Color iconColor;

  /// El valor numérico de la estadística, convertido a texto.
  final String value;

  /// El título o etiqueta de la estadística (ej. "Partidas").
  final String title;

  /// Crea una instancia de [StatCard].
  ///
  /// @param key El identificador opcional para el widget.
  /// @param icon El icono a mostrar.
  /// @param iconColor El color del icono.
  /// @param value El valor formateado a mostrar.
  /// @param title El título de la estadística.
  const StatCard({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.title,
  }) : super(key: key);

  /// Construye la representación gráfica de la tarjeta de estadística.
  ///
  /// @param context El contexto de construcción actual.
  /// @return Un [Widget] de tipo [Card] con la información centrada.
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
