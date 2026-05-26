import 'package:flutter/material.dart';

/// Widget reutilizable que representa un botón en formato tarjeta dentro de la cuadrícula del Hub.
///
/// Muestra un icono destacado, un título y una descripción, proporcionando
/// un diseño interactivo para navegar a las diferentes secciones secundarias
/// de la aplicación (Grupos, Ranking, Cómo jugar, etc.).
class HubGridItem extends StatelessWidget {
  /// El título principal de la tarjeta.
  final String title;

  /// Texto secundario breve que describe la acción de la tarjeta.
  final String description;

  /// El icono visual que representa la sección.
  final IconData icon;

  /// El color de acento utilizado para el icono y su fondo decorativo.
  final Color iconColor;

  /// La función a ejecutar cuando el usuario toca la tarjeta.
  final VoidCallback onTap;

  /// Crea una instancia de [HubGridItem].
  ///
  /// @param key El identificador opcional para el widget.
  /// @param title El título de la opción de navegación.
  /// @param description La descripción secundaria.
  /// @param icon El [IconData] a mostrar.
  /// @param iconColor El [Color] principal para acentuar la tarjeta.
  /// @param onTap El callback de pulsación.
  const HubGridItem({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  }) : super(key: key);

  /// Construye la representación visual de la tarjeta interactiva.
  ///
  /// @param context El contexto de construcción actual.
  /// @return Un [Widget] interactivo envolviendo el diseño.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 32),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
