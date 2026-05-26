import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:guess_it/features/game/domain/entities/team_entity.dart';
import 'package:guess_it/features/groups/domain/entities/group_entity.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_bloc.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_event.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_state.dart';
import 'package:guess_it/features/game/presentation/widgets/team_setup_card.dart';
import 'package:guess_it/features/game/presentation/widgets/game_settings_card.dart';
import 'package:guess_it/features/game/presentation/widgets/ai_settings_section.dart';

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
      teamControllers[1].text = 'Gessi - ${diffs[aiDifficulty]}';
    } else if (!isAiOpponent &&
        teamControllers.length > 1 &&
        teamControllers[1].text.startsWith('Gessi')) {
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

    // Comprobar si ya existe en algún equipo
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

  void _loadGroup(GroupEntity group, {bool keepHostIndex = false}) {
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
          'Necesitas al menos 2 personas en total (Tú + 1 amigo) para enfrentaros a la maquina.',
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
        selectedHostIndex = 0;
        teamEmailsLists[0].addAll(shuffled);
      } else {
        // Modo Competitivo: respetamos el equipo del anfitrión si keepHostIndex=true
        if (!keepHostIndex) selectedHostIndex = 0;

        final int rivalTeamIndex = selectedHostIndex == 0 ? 1 : 0;

        if (shuffled.isNotEmpty) {
          // El primero de la lista va al equipo rival para asegurar al menos un rival
          teamEmailsLists[rivalTeamIndex].add(shuffled.first);

          // Repartimos el resto alternando entre el equipo del host y el rival
          for (int i = 1; i < shuffled.length; i++) {
            final int teamIndex =
                i % 2 == 1 ? selectedHostIndex : rivalTeamIndex;
            teamEmailsLists[teamIndex].add(shuffled[i]);
          }
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
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 32,
                    left: 32,
                    right: 32,
                    bottom: MediaQuery.of(context).padding.bottom + 32,
                  ),
                  child: const Text(
                    'No tienes grupos.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return SafeArea(
              bottom: true,
              child: Padding(
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
                              );
                              _loadGroup(
                                group,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
          'Puedes ponerles el nombre que quieras, pero no el mismo nombre para dos equipos. Por defecto hay dos, pero puedes añadir más.\n\n'
          '✉️ 2. Añade a los jugadores:\n'
          'Escribe el nombre de tus amigos debajo de su equipo y pulsa Enter. ¡Ojo! Si quieres que sus victorias se guarden en su Perfil Global, debes escribir su correo electrónico registrado en lugar de su nombre.\n\n'
          '📥 3. Cargar desde Grupo:\n'
          'Si ya tienes un "grupo" guardado en la pestaña de Grupos, pulsa este botón para rellenar los equipos automáticamente. ¡Además, las victorias contarán para el Ranking Interno de ese grupo!\n\n'
          '🤖 4. Jugar contra Gessi:\n'
          '¿Os falta gente? Activa esta opción y el Equipo 2 será controlado por nuestro Bot.\n\n'
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
                  child: TeamSetupCard(
                    index: index,
                    teamController: controller,
                    emailInputController: emailInputControllers[index],
                    teamEmails: teamEmailsLists[index],
                    isAiOpponent: isAiOpponent,
                    onRemoveTeam: (teamControllers.length > 2 && index == teamControllers.length - 1)
                        ? () {
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
                          }
                        : null,
                    onEmailDeleted: (String email) {
                      setState(() {
                        teamEmailsLists[index].remove(email);
                        final bool allEmpty = teamEmailsLists.every((List<String> list) => list.isEmpty);
                        if (allEmpty) selectedGroup = null;
                      });
                    },
                    onEmailAdded: (String newEmail) {
                      _processEmailInput(index, newEmail);
                    },
                  ),
                );
              }),

              if (teamControllers.length < 6 &&
                  !isAiOpponent) // Si hay IA, no se pueden añadir más de 2 equipos
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

              GameSettingsCard(
                countController: countController,
                teamCount: teamControllers.length,
                selectedHostIndex: selectedHostIndex,
                selectedTurnDuration: selectedTurnDuration,
                onHostSelected: (int index) {
                  setState(() {
                    selectedHostIndex = index;
                    if (selectedGroup != null) {
                      _loadGroup(selectedGroup!, keepHostIndex: true);
                    }
                  });
                },
                onDurationChanged: (int duration) {
                  setState(() {
                    selectedTurnDuration = duration;
                  });
                },
              ),
              const SizedBox(height: 32),

              AiSettingsSection(
                isAiOpponent: isAiOpponent,
                aiDifficulty: aiDifficulty,
                onAiToggle: (bool value) {
                  setState(() {
                    isAiOpponent = value;
                    _updateAiName();

                    if (selectedGroup != null) {
                      _loadGroup(selectedGroup!);
                    } else {
                      if (isAiOpponent &&
                          teamEmailsLists.length > 1 &&
                          teamEmailsLists[1].isNotEmpty) {
                        teamEmailsLists[0].addAll(teamEmailsLists[1]);
                        teamEmailsLists[1].clear();
                      }
                    }
                  });
                },
                onDifficultyChanged: (int value) {
                  setState(() {
                    aiDifficulty = value;
                    _updateAiName();
                  });
                },
              ),
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
                  onPressed: () async {
                    // 1. VALIDACIONES LOCALES BÁSICAS (Nombres vacíos, cantidades, etc.)
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

                    // 2. COMPROBACIÓN EXPLICITA DE INTERNET Y CACHÉ LOCAL
                    bool hasInternet = true;
                    try {
                      final List<dynamic> result = await InternetAddress.lookup('google.com')
                          .timeout(const Duration(seconds: 4));
                      if (result.isEmpty || result[0].rawAddress.isEmpty) {
                        hasInternet = false;
                      }
                    } catch (_) {
                      hasInternet = false;
                    }

                    if (!hasInternet) {
                      bool hasCachedWords = false;
                      try {
                        // Comprobamos si hay palabras cacheadas localmente
                        final QuerySnapshot<Map<String, dynamic>> cacheQuery = await FirebaseFirestore.instance
                            .collection('words') // Colección de palabras de Firestore
                            .limit(1)
                            .get(const GetOptions(source: Source.cache));
                        hasCachedWords = cacheQuery.docs.isNotEmpty;
                      } catch (e) {
                        hasCachedWords = false;
                      }

                      if (hasCachedWords) {
                        // No hay internet, pero SÍ hay caché
                        await showCupertinoDialog<void>(
                          context: context,
                          builder: (BuildContext ctx) => CupertinoAlertDialog(
                            title: const Text('Modo Offline'),
                            content: const Text('Jugarás sin conexión usando las palabras guardadas en tu dispositivo. Las victorias se sincronizarán la próxima vez que te conectes.'),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: const Text('Entendido'),
                                onPressed: () => Navigator.of(ctx).pop(),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // No hay internet y NO hay caché
                        await showCupertinoDialog<void>(
                          context: context,
                          builder: (BuildContext ctx) => CupertinoAlertDialog(
                            title: const Text('Sin Conexión'),
                            content: const Text('No tienes acceso a internet ni palabras descargadas previamente. Solo se puede jugar incluyendo palabras manualmente en la siguiente pantalla.'),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: const Text('Entendido'),
                                onPressed: () => Navigator.of(ctx).pop(),
                              ),
                            ],
                          ),
                        );
                      }
                    }

                    if (hasInternet) {
                      // 3. INDICADOR DE CARGA ASÍNCRONO
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext ctx) => const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );

                      try {
                        // Leemos el estado del AuthBloc para saber si es invitado
                        final authState = context.read<AuthBloc>().state;
                        final bool isGuest = authState.user?.isGuest ?? true;
                        bool allTeamsValid = true;

                        // SOLO VALIDAMOS SI NO ES INVITADO
                        if (!isGuest) {
                          final String? hostEmail = FirebaseAuth.instance.currentUser?.email?.toLowerCase();

                          for (int i = 0; i < teamControllers.length; i++) {
                            if (isAiOpponent && i == 1) continue;

                            bool hasRegisteredInTeam = false;

                            if (i == selectedHostIndex && hostEmail != null && hostEmail.isNotEmpty) {
                              hasRegisteredInTeam = true;
                            }

                            if (!hasRegisteredInTeam) {
                              for (final String emailOrName in teamEmailsLists[i]) {
                                final String cleanEmail = emailOrName.trim().toLowerCase();
                                if (cleanEmail.contains('@')) {
                                  final QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
                                      .collection('users')
                                      .where('email', isEqualTo: cleanEmail)
                                      .limit(1)
                                      .get();
                                  if (query.docs.isNotEmpty) {
                                    hasRegisteredInTeam = true;
                                    break;
                                  }
                                }
                              }
                            }

                            if (!hasRegisteredInTeam) {
                              allTeamsValid = false;
                              break;
                            }
                          }
                        }

                        if (mounted) Navigator.of(context).pop(); // Cierra el indicador de carga

                        if (!isGuest && !allTeamsValid) {
                          _showCupertinoAlert(
                            context,
                            'Falta un Capitán',
                            'Cada equipo humano necesita al menos un jugador con cuenta registrada (email) para jugar.',
                          );
                          return;
                        }
                      } catch (e) {
                        if (mounted) Navigator.of(context).pop();
                        return;
                      }
                    }

                    // 4. CONTINUAR CON LA NAVEGACIÓN SI TODO ES CORRECTO
                    if (!mounted) return;
                    final String hostTeamName = teamControllers[selectedHostIndex].text.trim();
                    
                    // LECTURA SEGURA: Comprobamos el estado del BLoC en lugar de fiarnos del caché de Firebase
                    final authState = context.read<AuthBloc>().state;
                    final bool isGuest = authState.user?.isGuest ?? true;
                    final String? hostEmail = isGuest ? null : FirebaseAuth.instance.currentUser?.email?.toLowerCase();

                    final List<TeamEntity> initialTeams = <TeamEntity>[];

                    for (int i = 0; i < teamControllers.length; i++) {
                      final List<String> emails = List<String>.from(teamEmailsLists[i]);
                      
                      // Solo inyectamos al anfitrión si de verdad tiene una cuenta activa y no es invitado
                      if (hostEmail != null && hostEmail.isNotEmpty) {
                        emails.removeWhere((String email) => email.toLowerCase() == hostEmail);
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
