import 'package:flutter/material.dart';

/// Un widget reutilizable que representa visualmente una regla del juego.
///
/// Este widget de interfaz dibuja una tarjeta ([Card]) con esquinas redondeadas,
/// un icono destacado dentro de un círculo de color y un texto explicativo.
/// Ideal para pantallas de "Cómo jugar" o tutoriales.
class RuleCard extends StatelessWidget {
  /// El título principal de la regla.
  final String title;

  /// La descripción detallada de la regla.
  final String description;

  /// El icono visual que acompaña a la regla.
  final IconData icon;

  /// El color principal utilizado para el icono y su fondo decorativo.
  final Color color;

  /// Crea una instancia de [RuleCard].
  ///
  /// @param key El identificador opcional para el widget.
  /// @param title El título de la regla.
  /// @param description El texto explicativo de la regla.
  /// @param icon El [IconData] a mostrar.
  /// @param color El [Color] principal para acentuar el diseño.
  const RuleCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  }) : super(key: key);

  /// Construye la representación visual de la tarjeta de regla.
  ///
  /// @param context El contexto de construcción actual.
  /// @return Un [Widget] que renderiza la tarjeta de regla.
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
