import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';
import 'package:guess_it/features/game/domain/entities/team_entity.dart';

class GameSetupPage extends StatefulWidget {
  @override
  final Key? key;

  const GameSetupPage({Key? key}) : key = key;

  @override
  State<GameSetupPage> createState() {
    return _GameSetupPageState();
  }
}

class _GameSetupPageState extends State<GameSetupPage> {
  final List<TextEditingController> teamControllers = <TextEditingController>[];
  final List<List<String>> teamEmailsLists = <List<String>>[];
  final List<TextEditingController> emailInputControllers = <TextEditingController>[];
  final TextEditingController countController = TextEditingController();
  int selectedHostIndex = 0;
  int selectedTurnDuration = 30;

  @override
  void initState() {
    super.initState();
    _addTeam();
    _addTeam();
  }

  void _addTeam() {
    teamControllers.add(TextEditingController());
    teamEmailsLists.add(<String>[]);
    emailInputControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    for (final TextEditingController controller in teamControllers) {
      controller.dispose();
    }
    for (final TextEditingController controller in emailInputControllers) {
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

  bool _isValidEmail(String email) {
    final RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regex.hasMatch(email);
  }

  void _processEmailInput(int index, String value) {
    final String newEmail = value.trim().toLowerCase();
    if (newEmail.isNotEmpty && _isValidEmail(newEmail) && !teamEmailsLists[index].contains(newEmail)) {
      setState(() {
        teamEmailsLists[index].add(newEmail);
        emailInputControllers[index].clear();
      });
    } else {
      emailInputControllers[index].clear();
      if (newEmail.isNotEmpty && !_isValidEmail(newEmail)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Formato de correo no válido.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: 'Configurar Partida',
      showBackArrow: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ...teamControllers.asMap().entries.map((MapEntry<int, TextEditingController> entry) {
                final int index = entry.key;
                final TextEditingController controller = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Card(
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
                              if (teamControllers.length > 2 && index == teamControllers.length - 1)
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      final TextEditingController removed = teamControllers.removeLast();
                                      removed.dispose();
                                      teamEmailsLists.removeLast();
                                      final TextEditingController removedEmail = emailInputControllers.removeLast();
                                      removedEmail.dispose();
                                      if (selectedHostIndex >= teamControllers.length) {
                                        selectedHostIndex = teamControllers.length - 1;
                                      }
                                    });
                                  },
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              labelText: 'Nombre del Equipo',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              ),
                              prefixIcon: Icon(Icons.group),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (teamEmailsLists[index].isNotEmpty) ...<Widget>[
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: teamEmailsLists[index].map((String email) {
                                return InputChip(
                                  backgroundColor: Colors.purple.withOpacity(0.1),
                                  label: Text(email, style: const TextStyle(color: Colors.purple)),
                                  deleteIcon: const Icon(Icons.close, size: 18, color: Colors.purple),
                                  onDeleted: () {
                                    setState(() {
                                      teamEmailsLists[index].remove(email);
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                          ],
                          TextField(
                            controller: emailInputControllers[index],
                            decoration: const InputDecoration(
                              labelText: 'Añadir correo de usuario (Opcional)',
                              hintText: 'Presiona Enter o Coma para añadir',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              ),
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (String value) {
                              if (value.endsWith(',')) {
                                final String newEmail = value.substring(0, value.length - 1);
                                _processEmailInput(index, newEmail);
                              }
                            },
                            onSubmitted: (String value) {
                              _processEmailInput(index, value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              
              if (teamControllers.length < 6)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _addTeam();
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Añadir Equipo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Colors.purple, width: 2),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.purple,
                      elevation: 4,
                    ),
                  ),
                ),

              Card(
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
                      const Text(
                        'Ajustes de Partida',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: countController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Cantidad total de palabras',
                          hintText: 'Ej. 30, 40, 60',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          prefixIcon: Icon(Icons.format_list_numbered),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        '¿En qué equipo juegas tú (Anfitrión)?',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: teamControllers.asMap().entries.map((MapEntry<int, TextEditingController> entry) {
                          final int index = entry.key;
                          final bool isSelected = selectedHostIndex == index;
                          return ChoiceChip(
                            label: Text('Equipo ${index + 1}'),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              if (selected) {
                                setState(() {
                                  selectedHostIndex = index;
                                });
                              }
                            },
                            selectedColor: Colors.purple.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.purple : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Duración del turno (segundos)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoSlidingSegmentedControl<int>(
                          groupValue: selectedTurnDuration,
                          children: const <int, Widget>{
                            30: Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('30s')),
                            45: Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('45s')),
                            60: Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('60s')),
                          },
                          onValueChanged: (int? value) {
                            if (value != null) {
                              setState(() {
                                selectedTurnDuration = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: const LinearGradient(
                    colors: <Color>[Colors.purpleAccent, Colors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    final bool hasEmptyTeam = teamControllers.any((TextEditingController c) => c.text.trim().isEmpty);
                    
                    if (hasEmptyTeam) {
                      _showCupertinoAlert(
                        context, 
                        'Equipos Incompletos', 
                        'Por favor, introduce un nombre para todos los equipos.',
                      );
                      return;
                    }
                    
                    final List<String> teamNames = teamControllers.map((TextEditingController c) => c.text.trim()).toList();
                    final Set<String> uniqueNames = teamNames.map((String name) => name.toUpperCase()).toSet();
                    
                    if (uniqueNames.length != teamNames.length) {
                      _showCupertinoAlert(
                        context, 
                        'Nombres Repetidos', 
                        'Por favor, introduce nombres únicos para cada equipo.',
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

                    final String hostTeamName = teamControllers[selectedHostIndex].text.trim();

                    final String? hostEmail = FirebaseAuth.instance.currentUser?.email;
                    final List<TeamEntity> initialTeams = <TeamEntity>[];

                    for (int i = 0; i < teamControllers.length; i++) {
                      final List<String> emails = List<String>.from(teamEmailsLists[i]);

                      // Auto-inyectar el correo del host en el equipo seleccionado si está logueado
                      if (i == selectedHostIndex && hostEmail != null && hostEmail.isNotEmpty) {
                        if (!emails.contains(hostEmail)) {
                          emails.add(hostEmail);
                        }
                      }

                      initialTeams.add(
                        TeamEntity(
                          name: teamControllers[i].text.trim(), 
                          score: 0, 
                          registeredEmails: emails,
                        )
                      );
                    }

                    context.push(
                      '/custom-words',
                      extra: <String, dynamic>{
                        'initialTeams': initialTeams,
                        'targetCount': targetCount,
                        'hostTeamName': hostTeamName,
                        'turnDurationSeconds': selectedTurnDuration,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Text(
                    'Siguiente',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
