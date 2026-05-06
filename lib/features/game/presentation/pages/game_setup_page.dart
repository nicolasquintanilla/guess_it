import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameSetupPage extends StatefulWidget {
  const GameSetupPage();

  @override
  State<GameSetupPage> createState() {
    return _GameSetupPageState();
  }
}

class _GameSetupPageState extends State<GameSetupPage> {
  final List<TextEditingController> teamControllers = <TextEditingController>[];
  final TextEditingController countController = TextEditingController();
  int selectedHostIndex = 0;

  @override
  void initState() {
    super.initState();
    // Inyectamos 2 equipos iniciales (mínimo obligatorio)
    teamControllers.add(TextEditingController());
    teamControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    for (final TextEditingController controller in teamControllers) {
      controller.dispose();
    }
    countController.dispose();
    super.dispose();
  }

  void _showCupertinoAlert(BuildContext context, String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Entendido'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar Partida')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ...teamControllers.asMap().entries.map((
                MapEntry<int, TextEditingController> entry,
              ) {
                final int index = entry.key;
                final TextEditingController controller = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            labelText: 'Nombre Equipo ${index + 1}',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      if (teamControllers.length > 2 &&
                          index == teamControllers.length - 1) ...<Widget>[
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              final TextEditingController removed =
                                  teamControllers.removeLast();
                              removed.dispose();
                              if (selectedHostIndex >= teamControllers.length) {
                                selectedHostIndex = teamControllers.length - 1;
                              }
                            });
                          },
                        ),
                      ],
                    ],
                  ),
                );
              }),
              if (teamControllers.length < 6)
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      teamControllers.add(TextEditingController());
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Añadir Equipo'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              TextField(
                controller: countController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad total de palabras',
                  hintText: 'Ej. 30, 40, 60',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                '¿En qué equipo juegas tú (Anfitrión)?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: teamControllers.asMap().entries.map((
                  MapEntry<int, TextEditingController> entry,
                ) {
                  final int index = entry.key;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Radio<int>(
                        value: index,
                        groupValue: selectedHostIndex,
                        onChanged: (int? value) {
                          if (value != null) {
                            setState(() {
                              selectedHostIndex = value;
                            });
                          }
                        },
                      ),
                      Text('Equipo ${index + 1}'),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  final bool hasEmptyTeam = teamControllers.any(
                    (TextEditingController c) => c.text.trim().isEmpty,
                  );

                  if (hasEmptyTeam) {
                    _showCupertinoAlert(
                      context,
                      'Equipos Incompletos',
                      'Por favor, introduce un nombre para todos los equipos.',
                    );
                    return;
                  }

                  final String countStr = countController.text.trim();
                  if (countStr.isEmpty) {
                    _showCupertinoAlert(
                      context,
                      'Faltan Palabras',
                      'Por favor, introduce la cantidad de palabras a jugar.',
                    );
                    return;
                  }

                  final int? targetCount = int.tryParse(countStr);
                  if (targetCount == null || targetCount <= 0) {
                    _showCupertinoAlert(
                      context,
                      'Cantidad Inválida',
                      'La cantidad de palabras debe ser un número entero mayor a cero.',
                    );
                    return;
                  }

                  final List<String> teamNames = teamControllers
                      .map((TextEditingController c) => c.text.trim())
                      .toList();
                  final String hostTeamName = teamControllers[selectedHostIndex]
                      .text
                      .trim();

                  context.push(
                    '/custom-words',
                    extra: <String, dynamic>{
                      'teamNames': teamNames,
                      'targetCount': targetCount,
                      'hostTeamName': hostTeamName,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Siguiente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
