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

  const GroupDetailsPage({
    Key? key,
    required GroupEntity group,
  })  : key = key,
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
      const SnackBar(content: Text('Código copiado al portapapeles'), backgroundColor: Colors.green, duration: Duration(seconds: 2)),
    );
  }

  Future<void> _inviteViaWhatsApp() async {
    final String message = '¡Únete a mi grupo "${widget.group.name}" en Guess It! Nuestro código secreto es: ${widget.group.joinCode}';
    final Uri url = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(message)}');

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Error al abrir WhatsApp: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      listener: (BuildContext context, GroupState state) {
        if (state.status == GroupStatus.success && state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          if (state.successMessage == 'Grupo eliminado' || state.successMessage == 'Has salido del grupo') {
            context.pop();
          }
        }
      },
      child: PremiumScaffold(
        title: widget.group.name,
        showBackArrow: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            onPressed: () {
              final authState = context.read<AuthBloc>().state;
              final bool isHost = authState.user?.id == widget.group.hostId;
              showCupertinoDialog(
                context: context,
                builder: (BuildContext ctx) => CupertinoAlertDialog(
                  title: Text(isHost ? 'Eliminar Grupo' : 'Salir del Grupo'),
                  content: Text(isHost ? 'Esta acción borrará el grupo para todos.' : 'Dejarás de pertenecer a este grupo.'),
                  actions: <Widget>[
                    CupertinoDialogAction(child: const Text('Cancelar'), onPressed: () => Navigator.pop(ctx)),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      child: const Text('Confirmar'),
                      onPressed: () {
                        Navigator.pop(ctx);
                        if (isHost) {
                          context.read<GroupBloc>().add(DeleteGroupEvent(groupId: widget.group.id));
                        } else {
                          context.read<GroupBloc>().add(LeaveGroupEvent(groupId: widget.group.id));
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          )
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
                              widget.group.joinCode,
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
                'Integrantes (${widget.group.memberNames.length})',
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
                  itemCount: widget.group.memberNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.person, color: Colors.purple),
                        title: Text(
                          widget.group.memberNames[index],
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
      ),
    );
  }
}
