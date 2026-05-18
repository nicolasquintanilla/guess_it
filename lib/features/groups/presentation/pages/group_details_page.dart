import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';
import 'package:guess_it/features/groups/domain/entities/group_entity.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_bloc.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_event.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_state.dart';

class GroupDetailsPage extends StatefulWidget {
  final GroupEntity group;

  @override
  final Key? key;

  const GroupDetailsPage({Key? key, required GroupEntity group})
    : key = key,
      group = group;

  @override
  State<GroupDetailsPage> createState() {
    return _GroupDetailsPageState();
  }
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.group.joinCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Código copiado al portapapeles'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _inviteViaWhatsApp() async {
    final String message =
        '¡Únete a mi grupo "${widget.group.name}" en Guess It! Nuestro código secreto es: ${widget.group.joinCode}';
    final Uri url = Uri.parse(
      'https://wa.me/?text=${Uri.encodeComponent(message)}',
    );

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Error al abrir WhatsApp: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = context.read<AuthBloc>().state.user?.id;
    // Buscamos el grupo actualizado en el estado del BLoC. Si aún no ha llegado,
    // usamos el objeto estático que llegó por el router como fallback.
    final GroupEntity group = context.read<GroupBloc>().state.groups.firstWhere(
      (GroupEntity g) => g.id == widget.group.id,
      orElse: () => widget.group,
    );
    final bool isHost = currentUserId == group.hostId;

    return BlocConsumer<GroupBloc, GroupState>(
      listener: (BuildContext context, GroupState state) {
        if (state.status == GroupStatus.success &&
            state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          if (state.successMessage == 'Grupo eliminado' ||
              state.successMessage == 'Has salido del grupo') {
            context.pop();
          } else if (state.successMessage == 'Miembro expulsado del grupo.') {
            context.pop();
          }
        }
      },
      builder: (BuildContext context, GroupState blocState) {
        // Obtenemos la versión más actualizada del grupo desde el estado
        final GroupEntity liveGroup = blocState.groups.firstWhere(
          (GroupEntity g) => g.id == widget.group.id,
          orElse: () => group,
        );

        return PremiumScaffold(
          title: liveGroup.name,
          showBackArrow: true,
          helpText:
              'Detalles del Grupo 👥\n\n'
              'Aquí puedes ver y gestionar toda la información de esta sala.\n\n'
              '🔗 Código de Invitación:\n'
              'Cópialo o envíalo por WhatsApp para que tus amigos se unan.\n\n'
              '🧑🤝🧑 Integrantes:\n'
              'Lista de todos los jugadores unidos. El jugador con la corona (👑) es el Anfitrión. Si tú eres el Anfitrión, puedes expulsar a otros jugadores.\n\n'
              '🏆 Ranking del Grupo:\n'
              'Puntuaciones acumuladas por los miembros de este grupo en sus partidas conjuntas.',
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
              onPressed: () {
                final authState = context.read<AuthBloc>().state;
                final bool isHostAction =
                    authState.user?.id == liveGroup.hostId;
                showCupertinoDialog(
                  context: context,
                  builder: (BuildContext ctx) => CupertinoAlertDialog(
                    title: Text(
                      isHostAction ? 'Eliminar Grupo' : 'Salir del Grupo',
                    ),
                    content: Text(
                      isHostAction
                          ? 'Esta acción borrará el grupo para todos.'
                          : 'Dejarás de pertenecer a este grupo.',
                    ),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: const Text('Confirmar'),
                        onPressed: () {
                          Navigator.pop(ctx);
                          if (isHostAction) {
                            context.read<GroupBloc>().add(
                              DeleteGroupEvent(groupId: liveGroup.id),
                            );
                          } else {
                            context.read<GroupBloc>().add(
                              LeaveGroupEvent(groupId: liveGroup.id),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
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
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    liveGroup.joinCode,
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      letterSpacing: 4.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(
                                  Icons.copy_all,
                                  color: Colors.grey,
                                ),
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                  'Integrantes (${liveGroup.memberNames.length})',
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
                    itemCount: liveGroup.memberNames.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String memberName = liveGroup.memberNames[index];
                      final String memberEmail =
                          (index < liveGroup.memberEmails.length)
                          ? liveGroup.memberEmails[index]
                          : '';

                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.person,
                            color: Colors.purple,
                          ),
                          title: Text(
                            index == 0 ? '👑 $memberName' : memberName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          trailing:
                              (isHost &&
                                  memberName !=
                                      context
                                          .read<AuthBloc>()
                                          .state
                                          .user
                                          ?.username)
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.person_remove,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (BuildContext ctx) =>
                                          CupertinoAlertDialog(
                                            title: const Text(
                                              'Expulsar jugador',
                                            ),
                                            content: Text(
                                              '¿Seguro que quieres expulsar a $memberName del grupo?',
                                            ),
                                            actions: <Widget>[
                                              CupertinoDialogAction(
                                                child: const Text('Cancelar'),
                                                onPressed: () =>
                                                    Navigator.pop(ctx),
                                              ),
                                              CupertinoDialogAction(
                                                isDestructiveAction: true,
                                                child: const Text('Expulsar'),
                                                onPressed: () {
                                                  Navigator.pop(ctx);
                                                  context.read<GroupBloc>().add(
                                                    KickMemberEvent(
                                                      groupId: liveGroup.id,
                                                      memberName: memberName,
                                                      memberEmail: memberEmail,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Ranking del Grupo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16),
                if (liveGroup.scores.isEmpty)
                  const Text(
                    'Aún no hay puntuaciones. ¡Jugad una partida!',
                    style: TextStyle(color: Colors.white70),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: liveGroup.scores.length,
                      itemBuilder: (BuildContext context, int index) {
                        final List<MapEntry<String, int>> sortedScores =
                            liveGroup.scores.entries.toList()..sort(
                              (
                                MapEntry<String, int> a,
                                MapEntry<String, int> b,
                              ) => b.value.compareTo(a.value),
                            );
                        final MapEntry<String, int> entry = sortedScores[index];

                        return Card(
                          color: index == 0
                              ? Colors.amber.shade300
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            leading: index == 0
                                ? const Icon(
                                    Icons.emoji_events,
                                    color: Colors.white,
                                    size: 32,
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    child: Text(
                                      '#${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                            title: Text(
                              entry.key,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: index == 0
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            trailing: Text(
                              '${entry.value} pts',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                color: index == 0
                                    ? Colors.white
                                    : Colors.deepPurple,
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
      },
    );
  }
}
