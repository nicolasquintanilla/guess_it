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
import 'package:guess_it/features/groups/presentation/widgets/group_invite_section.dart';
import 'package:guess_it/features/groups/presentation/widgets/group_members_list.dart';
import 'package:guess_it/features/groups/presentation/widgets/group_ranking_placeholder.dart';

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GroupInviteSection(
                  joinCode: liveGroup.joinCode,
                  onCopy: () => _copyToClipboard(context),
                  onInvite: _inviteViaWhatsApp,
                ),
                const SizedBox(height: 32),
                GroupMembersList(
                  group: liveGroup,
                  isHost: isHost,
                  currentUserName: context.read<AuthBloc>().state.user?.username,
                  onExpel: (String name, String email) {
                    context.read<GroupBloc>().add(
                      KickMemberEvent(
                        groupId: liveGroup.id,
                        memberName: name,
                        memberEmail: email,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                const GroupRankingPlaceholder(),
              ],
            ),
          ),
        );
      },
    );
  }
}
