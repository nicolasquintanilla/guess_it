import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';
import 'package:guess_it/features/game/domain/entities/team_entity.dart';
import 'package:guess_it/features/groups/domain/entities/group_entity.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_bloc.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_event.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_state.dart';

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
  final List<TextEditingController> emailInputControllers =
      <TextEditingController>[];
  final TextEditingController countController = TextEditingController();
  int selectedHostIndex = 0;
  int selectedTurnDuration = 30;
  GroupEntity? selectedGroup;
  bool isAiOpponent = false;
  int aiDifficulty = 1; // 0=Fácil, 1=Media, 2=Difícil

  @override
  void initState() {
    super.initState();
    _addTeam();
    _addTeam();
    context.read<GroupBloc>().add(const LoadGroupsEvent());
  }

  void _addTeam() {
    teamControllers.add(TextEditingController());
    teamEmailsLists.add(<String>[]);
    emailInputControllers.add(TextEditingController());
  }

  void _updateAiName() {
    if (isAiOpponent && teamControllers.length > 1) {
      const List<String> diffs = <String>['Fácil', 'Media', 'Difícil'];
      teamControllers[1].text = 'IA Guess It - ${diffs[aiDifficulty]}';
    } else if (!isAiOpponent &&
        teamControllers.length > 1 &&
        teamControllers[1].text.startsWith('IA Guess It')) {
      teamControllers[1].text = '';
    }
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
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return regex.hasMatch(email);
  }

  void _processEmailInput(int index, String value) {
    final String input = value.trim();
    if (input.isEmpty) return;

    final String? hostEmail = FirebaseAuth.instance.currentUser?.email
        ?.toLowerCase();
    if (hostEmail != null && input.toLowerCase() == hostEmail) {
      _showCupertinoAlert(
        context,
        'Eres el Anfitrión',
        'Tú ya estás en la partida por defecto. Usa los selectores de "Anfitrión" de la parte inferior para elegir tu equipo.',
      );
      emailInputControllers[index].clear();
      return;
    }

    // Comprobar si ya existe en ALGÚN equipo
    bool exists = false;
    for (final List<String> list in teamEmailsLists) {
      if (list.any((String e) => e.toLowerCase() == input.toLowerCase())) {
        exists = true;
        break;
      }
    }

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este jugador ya está en un equipo.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      emailInputControllers[index].clear();
    } else {
      setState(() {
        teamEmailsLists[index].add(input);
        emailInputControllers[index].clear();
      });
    }
  }

  void _loadGroup(GroupEntity group) {
    final String? hostEmail = FirebaseAuth.instance.currentUser?.email
        ?.toLowerCase();
    final List<String> filteredEmails = group.memberEmails
        .where((String e) => e.toLowerCase() != hostEmail)
        .toList();

    // Validaciones según el modo de juego
    if (isAiOpponent) {
      if (filteredEmails.isEmpty) {
        _showCupertinoAlert(
          context,
          'Grupo insuficiente',
          'Necesitas al menos 2 personas en total (Tú + 1 amigo) para enfrentaros a la IA.',
        );
        return;
      }
    } else {
      if (filteredEmails.length < 3) {
        _showCupertinoAlert(
          context,
          'Grupo insuficiente',
          'Para jugar por equipos necesitáis ser al menos 4 personas en total (Tú + 3 amigos).',
        );
        return;
      }
    }

    setState(() {
      selectedGroup = group;
      for (final List<String> list in teamEmailsLists) {
        list.clear();
      }

      final List<String> shuffled = List<String>.from(filteredEmails)
        ..shuffle();

      if (isAiOpponent) {
        // Modo Cooperativo: Todos los amigos van al equipo del Anfitrión
        teamEmailsLists[selectedHostIndex].addAll(shuffled);
      } else {
        // Modo Competitivo: Reparto equitativo entre todos los equipos creados
        for (int i = 0; i < shuffled.length; i++) {
          final int teamIndex = i % teamControllers.length;
          teamEmailsLists[teamIndex].add(shuffled[i]);
        }
      }
    });
  }

  void _showGroupSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      builder: (BuildContext ctx) {
        return BlocBuilder<GroupBloc, GroupState>(
          builder: (BuildContext context, GroupState state) {
            if (state.groups.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No tienes grupos.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Selecciona un Grupo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.groups.length,
                      itemBuilder: (BuildContext context, int index) {
                        final GroupEntity group = state.groups[index];
                        return ListTile(
                          leading: const Icon(
                            Icons.group,
                            color: Colors.purple,
                          ),
                          title: Text(
                            group.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${group.memberNames.length} integrantes',
                          ),
                          onTap: () {
                            Navigator.pop(
                              ctx,
                            ); // Cierra el selector de grupos primero
                            _loadGroup(
                              group,
                            ); // Ejecuta la carga y muestra la alerta si falla
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: 'Configurar Partida',
      showBackArrow: true,
      helpText:
          '¡Prepárate para jugar a Guess It!\n\n'
          'Sigue estos pasos para configurar tu partida perfecta:\n\n'
          '👥 1. Crea los equipos:\n'
          'Puedes ponerles el nombre que quieras. Por defecto hay dos, pero puedes añadir más.\n\n'
          '✉️ 2. Añade a los jugadores:\n'
          'Escribe el nombre de tus amigos debajo de su equipo y pulsa Enter. ¡Ojo! Si quieres que sus victorias se guarden en su Perfil Global, debes escribir su correo electrónico registrado en lugar de su nombre.\n\n'
          '📥 3. Cargar desde Grupo:\n'
          'Si ya tienes una "escuadra" guardada en la pestaña de Grupos, pulsa este botón para rellenar los equipos automáticamente. ¡Además, las victorias contarán para el Ranking Interno de ese grupo!\n\n'
          '🤖 4. Jugar contra la IA:\n'
          '¿Os falta gente? Activa esta opción y el Equipo 2 será controlado por nuestra Inteligencia Artificial. ¡Cuidado, es muy rápida!\n\n'
          '👑 5. El Anfitrión:\n'
          'No olvides marcar en qué equipo estás tú para que los puntos se sumen a tu cuenta si ganas.',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showGroupSelection,
                  icon: const Icon(Icons.download, color: Colors.white),
                  label: Text(
                    selectedGroup != null
                        ? 'Grupo: ${selectedGroup!.name}'
                        : 'Cargar desde Grupo',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...teamControllers.asMap().entries.map((
                MapEntry<int, TextEditingController> entry,
              ) {
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
                              if (teamControllers.length > 2 &&
                                  index == teamControllers.length - 1)
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      final TextEditingController removed =
                                          teamControllers.removeLast();
                                      removed.dispose();
                                      teamEmailsLists.removeLast();
                                      final TextEditingController removedEmail =
                                          emailInputControllers.removeLast();
                                      removedEmail.dispose();
                                      if (selectedHostIndex >=
                                          teamControllers.length) {
                                        selectedHostIndex =
                                            teamControllers.length - 1;
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
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              prefixIcon: Icon(Icons.group),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (teamEmailsLists[index].isNotEmpty) ...<Widget>[
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: teamEmailsLists[index].map((
                                String email,
                              ) {
                                return InputChip(
                                  backgroundColor: Colors.purple.withOpacity(
                                    0.1,
                                  ),
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
                                  onDeleted: () {
                                    setState(() {
                                      teamEmailsLists[index].remove(email);
                                      final bool allEmpty = teamEmailsLists
                                          .every(
                                            (List<String> list) => list.isEmpty,
                                          );
                                      if (allEmpty) selectedGroup = null;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (!(isAiOpponent && index == 1)) ...<Widget>[
                            TextField(
                              controller: emailInputControllers[index],
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
                                  _processEmailInput(index, newEmail);
                                }
                              },
                              onSubmitted: (String value) {
                                _processEmailInput(index, value);
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }),

              if (teamControllers.length < 6 && !isAiOpponent) // Si hay IA, no se pueden añadir más de 2 equipos
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: teamControllers.asMap().entries.map((
                          MapEntry<int, TextEditingController> entry,
                        ) {
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
                              color: isSelected
                                  ? Colors.purple
                                  : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Duración del turno (segundos)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoSlidingSegmentedControl<int>(
                          groupValue: selectedTurnDuration,
                          children: const <int, Widget>{
                            30: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text('30s'),
                            ),
                            45: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text('45s'),
                            ),
                            60: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text('60s'),
                            ),
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

              SwitchListTile(
                title: const Text(
                  '¿Jugar contra la IA?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'El Equipo 2 será controlado por la máquina',
                  style: TextStyle(color: Colors.white70),
                ),
                value: isAiOpponent,
                activeColor: Colors.orangeAccent,
                onChanged: (bool value) {
                  setState(() {
                    isAiOpponent = value;
                    _updateAiName();

                    if (selectedGroup != null) {
                      _loadGroup(
                        selectedGroup!,
                      ); // Redistribuye el grupo cargado
                    } else {
                      // Si lo han metido a mano, movemos a los humanos del Equipo 2 al Equipo 1 para no perderlos
                      if (isAiOpponent &&
                          teamEmailsLists.length > 1 &&
                          teamEmailsLists[1].isNotEmpty) {
                        teamEmailsLists[0].addAll(teamEmailsLists[1]);
                        teamEmailsLists[1].clear();
                      }
                    }
                  });
                },
              ),
              if (isAiOpponent) ...<Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Dificultad de la Máquina',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: CupertinoSlidingSegmentedControl<int>(
                      groupValue: aiDifficulty,
                      backgroundColor: Colors.black26,
                      thumbColor: Colors.white,
                      children: <int, Widget>{
                        0: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Fácil',
                            style: TextStyle(
                              color: aiDifficulty == 0
                                  ? Colors.deepPurple
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        1: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Media',
                            style: TextStyle(
                              color: aiDifficulty == 1
                                  ? Colors.deepPurple
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        2: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Difícil',
                            style: TextStyle(
                              color: aiDifficulty == 2
                                  ? Colors.deepPurple
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      },
                      onValueChanged: (int? value) {
                        if (value != null) {
                          setState(() {
                            aiDifficulty = value;
                            _updateAiName();
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              const SizedBox(height: 16),

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

                    int totalHumanPlayers = 1; // El anfitrión cuenta como 1
                    for (int i = 0; i < teamControllers.length; i++) {
                      if (isAiOpponent && i == 1)
                        continue; // No contamos a la máquina
                      totalHumanPlayers += teamEmailsLists[i].length;
                    }

                    if (isAiOpponent && totalHumanPlayers < 2) {
                      _showCupertinoAlert(
                        context,
                        'Faltan Jugadores',
                        'Para jugar contra la IA necesitáis ser al menos 2 personas en tu equipo. Es necesarios escribir el correo electrnico de los jugadores si estan dados de alta en el sistema o poner su nombre en caso de que no lo esten.',
                      );
                      return;
                    } else if (!isAiOpponent && totalHumanPlayers < 4) {
                      _showCupertinoAlert(
                        context,
                        'Faltan Jugadores',
                        'Para jugar Humanos vs Humanos necesitáis ser al menos 4 personas en total. Es necesarios escribir el correo electrnico de los jugadores si estan dados de alta en el sistema o poner su nombre en caso de que no lo esten.',
                      );
                      return;
                    }

                    final List<String> teamNames = teamControllers
                        .map((TextEditingController c) => c.text.trim())
                        .toList();
                    final Set<String> uniqueNames = teamNames
                        .map((String name) => name.toUpperCase())
                        .toSet();

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

                    final String hostTeamName =
                        teamControllers[selectedHostIndex].text.trim();

                    final String? hostEmail =
                        FirebaseAuth.instance.currentUser?.email;
                    final List<TeamEntity> initialTeams = <TeamEntity>[];

                    for (int i = 0; i < teamControllers.length; i++) {
                      final List<String> emails = List<String>.from(
                        teamEmailsLists[i],
                      );

                      if (hostEmail != null && hostEmail.isNotEmpty) {
                        // 1. Eliminamos el correo del anfitrión de TODOS los equipos por si lo metió a mano por error
                        emails.removeWhere(
                          (String email) =>
                              email.toLowerCase() == hostEmail.toLowerCase(),
                        );

                        // 2. Lo inyectamos EXCLUSIVAMENTE en el equipo que ha marcado como Anfitrión
                        if (i == selectedHostIndex) {
                          emails.add(hostEmail);
                        }
                      }

                      initialTeams.add(
                        TeamEntity(
                          name: teamControllers[i].text.trim(),
                          score: 0,
                          registeredEmails: emails,
                        ),
                      );
                    }

                    context.push(
                      '/custom-words',
                      extra: <String, dynamic>{
                        'initialTeams': initialTeams,
                        'targetCount': targetCount,
                        'hostTeamName': hostTeamName,
                        'turnDurationSeconds': selectedTurnDuration,
                        'groupId': selectedGroup?.id,
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
