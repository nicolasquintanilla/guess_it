import 'dart:io';

/// Clase utilitaria para comprobar la conectividad a Internet del dispositivo.
class NetworkChecker {
  /// Comprueba si el dispositivo tiene acceso activo a Internet realizando
  /// una búsqueda DNS hacia un servidor fiable (google.com) con un límite de tiempo.
  ///
  /// @return Un [Future] que se resuelve a `true` si hay conexión activa,
  /// o `false` en caso de error, timeout o falta de red.
  static Future<bool> hasConnection() async {
    try {
      final List<InternetAddress> result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
