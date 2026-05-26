import 'package:flutter/material.dart';

/// Vista estática que se muestra a los usuarios no registrados en la sección de perfil.
///
/// Dado que los invitados no persisten estadísticas en la base de datos,
/// este widget muestra un mensaje invitándoles a registrarse.
class GuestProfileView extends StatelessWidget {
  /// Crea una instancia de [GuestProfileView].
  ///
  /// @param key El identificador opcional para el widget.
  const GuestProfileView({Key? key}) : super(key: key);

  /// Construye la representación gráfica del mensaje para invitados.
  ///
  /// @param context El contexto de construcción actual.
  /// @return Un [Widget] centrado con un icono y texto descriptivo.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.no_accounts,
              size: 150,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(height: 32),
            const Text(
              'Los invitados no guardan estadísticas. ¡Regístrate para competir!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
