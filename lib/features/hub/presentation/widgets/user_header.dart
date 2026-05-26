import 'package:flutter/material.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_state.dart';

/// Widget que renderiza la cabecera del usuario en la pantalla principal (Hub).
///
/// Muestra el avatar dinámico seleccionado por el usuario y su nombre
/// de visualización, indicando si se encuentra en modo "Invitado".
class UserHeader extends StatelessWidget {
  /// El estado actual de autenticación que contiene los datos del usuario.
  final AuthState authState;

  /// Mapa que relaciona las claves de los avatares con sus rutas de imagen.
  final Map<String, String> availableAvatars;

  /// Crea una instancia de [UserHeader].
  ///
  /// @param key El identificador opcional para el widget.
  /// @param authState Estado del BLoC de autenticación con la sesión activa.
  /// @param availableAvatars Diccionario de avatares disponibles en la app.
  const UserHeader({
    Key? key,
    required this.authState,
    required this.availableAvatars,
  }) : super(key: key);

  /// Construye la visualización de la información básica del perfil.
  ///
  /// @param context El contexto de construcción actual.
  /// @return Un [Widget] tipo Row con la imagen del avatar y el nombre de usuario.
  @override
  Widget build(BuildContext context) {
    final bool isGuest = authState.user?.isGuest ?? true;
    final String displayUsername = isGuest
        ? 'Invitado'
        : (authState.user?.username ?? 'Invitado');

    return Row(
      children: <Widget>[
        Builder(
          builder: (context) {
            final String avatarKey = authState.user?.avatar ?? 'none';
            final bool isSimple =
                avatarKey == 'none' ||
                !availableAvatars.containsKey(avatarKey);
            final double avatarSize = 64;

            final Widget avatarWidget = isSimple
                ? Icon(
                    Icons.person_pin,
                    key: const ValueKey<String>('simple_avatar'),
                    color: Colors.grey,
                    size: avatarSize * 0.8,
                  )
                : Image.asset(
                    availableAvatars[avatarKey]!,
                    key: ValueKey<String>(avatarKey),
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                  );

            return Container(
              width: avatarSize,
              height: avatarSize,
              decoration: null,
              child: Center(child: avatarWidget),
            );
          },
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                displayUsername,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
