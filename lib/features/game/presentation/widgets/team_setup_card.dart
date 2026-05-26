import 'package:flutter/material.dart';

class TeamSetupCard extends StatelessWidget {
  final int index;
  final TextEditingController teamController;
  final TextEditingController emailInputController;
  final List<String> teamEmails;
  final bool isAiOpponent;
  final VoidCallback? onRemoveTeam;
  final Function(String) onEmailDeleted;
  final Function(String) onEmailAdded;

  const TeamSetupCard({
    Key? key,
    required this.index,
    required this.teamController,
    required this.emailInputController,
    required this.teamEmails,
    required this.isAiOpponent,
    this.onRemoveTeam,
    required this.onEmailDeleted,
    required this.onEmailAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Equipo ${index + 1}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (onRemoveTeam != null)
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                    ),
                    onPressed: onRemoveTeam,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: teamController,
              maxLength: 15,
              enabled: !(isAiOpponent && index == 1),
              style: TextStyle(
                color: (isAiOpponent && index == 1)
                    ? Colors.grey
                    : Colors.black87,
              ),
              decoration: InputDecoration(
                labelText: 'Nombre del Equipo',
                filled: isAiOpponent && index == 1,
                fillColor: (isAiOpponent && index == 1)
                    ? Colors.grey.withOpacity(0.1)
                    : null,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                prefixIcon: const Icon(Icons.group),
              ),
            ),
            const SizedBox(height: 16),
            if (teamEmails.isNotEmpty) ...<Widget>[
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: teamEmails.map((
                  String email,
                ) {
                  return InputChip(
                    backgroundColor: Colors.purple.withOpacity(0.1),
                    label: Text(
                      email,
                      style: const TextStyle(
                        color: Colors.purple,
                      ),
                    ),
                    deleteIcon: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.purple,
                    ),
                    onDeleted: () => onEmailDeleted(email),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
            if (!(isAiOpponent && index == 1)) ...<Widget>[
              TextField(
                controller: emailInputController,
                decoration: const InputDecoration(
                  labelText: 'Añadir Jugador (Correo o Nombre)',
                  hintText: 'Escribe y pulsa Enter',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (String value) {
                  if (value.endsWith(',')) {
                    final String newEmail = value.substring(
                      0,
                      value.length - 1,
                    );
                    onEmailAdded(newEmail);
                  }
                },
                onSubmitted: (String value) {
                  onEmailAdded(value);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
