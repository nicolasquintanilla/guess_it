import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static const String _serviceId = 'service_u1e8bsh';
  static const String _templateWelcomeId = 'template_th5cpeq';
  static const String _templateGoodbyeId = 'template_zajudvl';
  static const String _publicKey = '--bZrse3IJidU83YP';

  static const String _apiUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  /// Enviar correo de Bienvenida
  static Future<void> sendWelcomeEmail({
    required String userEmail,
    required String userName,
  }) async {
    await _sendEmail(
      templateId: _templateWelcomeId,
      templateParams: <String, dynamic>{
        'to_email': userEmail,
        'to_name': userName,
      },
    );
  }

  /// Enviar correo de Despedida (Cuenta Eliminada)
  static Future<void> sendGoodbyeEmail({
    required String userEmail,
    required String userName,
  }) async {
    await _sendEmail(
      templateId: _templateGoodbyeId,
      templateParams: <String, dynamic>{
        'to_email': userEmail,
        'to_name': userName,
      },
    );
  }

  /// Método privado genérico para hacer la petición HTTP
  static Future<void> _sendEmail({
    required String templateId,
    required Map<String, dynamic> templateParams,
  }) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(_apiUrl),
        headers: <String, String>{
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode(<String, dynamic>{
          'service_id': _serviceId,
          'template_id': templateId,
          'user_id': _publicKey,
          'template_params': templateParams,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Email enviado correctamente (Template: $templateId).');
      } else {
        print('❌ Error de EmailJS: ${response.body}');
      }
    } catch (e) {
      print('❌ Excepción al enviar email: $e');
      // Se captura en silencio para no romper el flujo del usuario
    }
  }
}
