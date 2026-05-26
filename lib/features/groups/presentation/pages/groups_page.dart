import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_state.dart';
import 'package:guess_it/features/groups/domain/entities/group_entity.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_bloc.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_event.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_state.dart';
import 'package:guess_it/features/groups/presentation/widgets/group_action_buttons.dart';
import 'package:guess_it/features/groups/presentation/widgets/empty_groups_view.dart';
import 'package:guess_it/features/groups/presentation/widgets/groups_list.dart';

class GroupsPage extends StatefulWidget {
  @override
  final Key? key;

  const GroupsPage({Key? key}) : key = key;

  @override
  State<GroupsPage> createState() {
    return _GroupsPageState();
  }
}

class _GroupsPageState extends State<GroupsPage> {
  final TextEditingController _createGroupController = TextEditingController();
  final TextEditingController _joinGroupController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (context.read<AuthBloc>().state.user?.isGuest == false) {
      context.read<GroupBloc>().add(const LoadGroupsEvent());
    }
  }

  @override
  void dispose() {
    _createGroupController.dispose();
    _joinGroupController.dispose();
    super.dispose();
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
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
                Navigator.of(ctx, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: const Text('Crear Nuevo Grupo'),
          content: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: CupertinoTextField(
              controller: _createGroupController,
              placeholder: 'Nombre del grupo',
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Crear'),
              onPressed: () {
                context.read<GroupBloc>().add(
                  CreateGroupEvent(
                    groupName: _createGroupController.text.trim(),
                  ),
                );
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showJoinGroupDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: const Text('Unirse a un Grupo'),
          content: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: CupertinoTextField(
              controller: _joinGroupController,
              placeholder: 'Código de 6 letras',
              textCapitalization: TextCapitalization.characters,
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Unirse'),
              onPressed: () {
                context.read<GroupBloc>().add(
                  JoinGroupEvent(
                    joinCode: _joinGroupController.text.trim().toUpperCase(),
                  ),
                );
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (BuildContext context, AuthState authState) {
        final bool isGuest = authState.user?.isGuest == true;

        return PremiumScaffold(
          title: 'Mis Grupos',
          showBackArrow: true,
          helpText:
              '¡Tu Zona de Juego Privada! 🚀\n\n'
              'Aquí puedes gestionar los grupos fijos para jugar con tus amigos.\n\n'
              '👑 Crear un Grupo:\n'
              'Genera una sala permanente. Como Anfitrión, tendrás el control total sobre la sala.\n\n'
              '🤝 Unirse con Código:\n'
              'Introduce el PIN de 6 letras que te comparta un amigo para unirte a su grupo.\n\n'
              '📋 Tus Grupos:\n'
              'Accede rápidamente a tus salas habituales. Si eres el Anfitrión, podrás editarlas o eliminarlas.',
          floatingActionButton: isGuest
              ? null
              : GroupActionButtons(
                  onCreatePressed: () => _showCreateGroupDialog(context),
                  onJoinPressed: () => _showJoinGroupDialog(context),
                ),
          child: isGuest
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.no_accounts, size: 120, color: Colors.white),
                        SizedBox(height: 24),
                        Text(
                          'Los invitados no pueden crear ni unirse a grupos. ¡Regístrate!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : BlocConsumer<GroupBloc, GroupState>(
                  listenWhen: (GroupState previous, GroupState current) =>
                      previous.status != current.status,
                  listener: (BuildContext context, GroupState state) {
                    if (state.status == GroupStatus.error) {
                      _showErrorDialog(
                        context,
                        'Error',
                        state.errorMessage ??
                            'Ha ocurrido un error inesperado.',
                      );
                    } else if (state.status == GroupStatus.success) {
                      _createGroupController.clear();
                      _joinGroupController.clear();
                    }
                  },
                  builder: (BuildContext context, GroupState state) {
                    if (state.status == GroupStatus.loading &&
                        state.groups.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    if (state.groups.isEmpty) {
                      return const EmptyGroupsView();
                    }

                    return GroupsList(
                      groups: state.groups,
                      onGroupTap: (GroupEntity group) {
                        context.push('/group-details', extra: group);
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
