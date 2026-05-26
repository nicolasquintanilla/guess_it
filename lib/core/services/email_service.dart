import 'dart:convert';
import 'package:http/http.dart' as http;

/// Servicio encargado de la gestión y envío de correos electrónicos transaccionales.
///
/// Utiliza la API de EmailJS para enviar correos utilizando plantillas preconfiguradas.
class EmailService {
  static const String _serviceId = 'service_u1e8bsh';
  static const String _templateWelcomeId = 'template_th5cpeq';
  static const String _templateGoodbyeId = 'template_zajudvl';
  static const String _publicKey = '--bZrse3IJidU83YP';

  static const String _apiUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  /// Envía un correo electrónico de bienvenida al usuario recién registrado.
  ///
  /// @param userEmail La dirección de correo electrónico del destinatario.
  /// @param userName El nombre del destinatario para personalizar el correo.
  /// @return Un [Future] que se completa cuando la solicitud de envío finaliza.
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

  /// Envía un correo electrónico de confirmación de eliminación de cuenta (Despedida).
  ///
  /// @param userEmail La dirección de correo electrónico del destinatario.
  /// @param userName El nombre del destinatario para personalizar el correo.
  /// @return Un [Future] que se completa cuando la solicitud de envío finaliza.
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
