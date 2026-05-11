import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';
import 'package:guess_it/features/groups/domain/entities/group_entity.dart';

class GroupDetailsPage extends StatelessWidget {
  final GroupEntity group;

  @override
  final Key? key;

  const GroupDetailsPage({
    Key? key,
    required GroupEntity group,
  })  : key = key,
        group = group;

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: group.joinCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Código copiado al portapapeles'), backgroundColor: Colors.green, duration: Duration(seconds: 2)),
    );
  }

  Future<void> _inviteViaWhatsApp() async {
    final String message = '¡Únete a mi grupo "${group.name}" en Guess It! Nuestro código secreto es: ${group.joinCode}';
    final Uri url = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(message)}');

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Error al abrir WhatsApp: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: group.name,
      showBackArrow: true,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Código de Invitación',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            group.joinCode,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              letterSpacing: 4.0,
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.copy_all, color: Colors.grey),
                            onPressed: () => _copyToClipboard(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _inviteViaWhatsApp,
                icon: const Icon(Icons.chat, color: Colors.white),
                label: const Text(
                  'Invitar por WhatsApp',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Integrantes (${group.memberNames.length})',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: group.memberNames.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.purple),
                      title: Text(
                        group.memberNames[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
