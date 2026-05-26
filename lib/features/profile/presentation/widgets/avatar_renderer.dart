import 'package:flutter/material.dart';

/// Widget encargado de renderizar visualmente un avatar.
///
/// Gestiona la lógica para mostrar una imagen desde los assets si la clave
/// es válida, o un icono por defecto si el usuario no tiene avatar seleccionado
/// o hay un error en la carga.
class AvatarRenderer extends StatelessWidget {
  /// Clave o identificador del avatar a mostrar (ej. 'astronauta').
  final String? avatarKey;

  /// Tamaño cuadrado (ancho y alto) asignado al avatar.
  final double size;

  /// Indica si el avatar debe mostrarse con un estilo de selección resaltado.
  final bool isSelected;

  /// Mapa que asocia las claves de avatares con las rutas de sus assets locales.
  final Map<String, String> availableAvatars;

  /// Clave especial (ej. 'none') que indica que se debe usar el icono genérico.
  final String defaultSimpleAvatarKey;

  /// Crea una instancia de [AvatarRenderer].
  ///
  /// @param key El identificador opcional para el widget.
  /// @param avatarKey La clave del avatar a renderizar.
  /// @param size El tamaño en píxeles.
  /// @param isSelected Si está seleccionado (por defecto `false`).
  /// @param availableAvatars Diccionario de rutas de imágenes.
  /// @param defaultSimpleAvatarKey Clave fallback para un icono simple.
  const AvatarRenderer({
    Key? key,
    required this.avatarKey,
    required this.size,
    this.isSelected = false,
    required this.availableAvatars,
    required this.defaultSimpleAvatarKey,
  }) : super(key: key);

  /// Construye la representación gráfica del avatar.
  ///
  /// @param context El contexto de construcción actual.
  /// @return Un [Widget] que contiene la imagen o el icono de respaldo.
  @override
  Widget build(BuildContext context) {
    if (avatarKey == null ||
        avatarKey == defaultSimpleAvatarKey ||
        !availableAvatars.containsKey(avatarKey)) {
      return Container(
        width: size,
        height: size,
        decoration: null,
        child: Center(
          child: Icon(
            Icons.person_pin,
            size: size * 0.8,
            color: Colors.grey,
          ),
        ),
      );
    }

    final String imagePath = availableAvatars[avatarKey]!;
    return Container(
      width: size,
      height: size,
      decoration: isSelected
          ? BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepPurple.withOpacity(0.2),
            )
          : null,
      padding: const EdgeInsets.all(4.0),
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => Container(
          width: size,
          height: size,
          color: Colors.red.withOpacity(0.1),
          child: Icon(
            Icons.help_outline,
            color: Colors.white,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}
