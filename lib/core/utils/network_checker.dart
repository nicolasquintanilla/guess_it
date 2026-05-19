import 'dart:io';

class NetworkChecker {
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
