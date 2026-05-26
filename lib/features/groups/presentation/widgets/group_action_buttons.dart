import 'package:flutter/material.dart';

class GroupActionButtons extends StatelessWidget {
  final VoidCallback onCreatePressed;
  final VoidCallback onJoinPressed;

  const GroupActionButtons({
    Key? key,
    required this.onCreatePressed,
    required this.onJoinPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FloatingActionButton.extended(
          heroTag: 'createGroupBtn',
          backgroundColor: Colors.white,
          foregroundColor: Colors.purple,
          icon: const Icon(Icons.add),
          label: const Text('Crear Grupo'),
          onPressed: onCreatePressed,
        ),
        const SizedBox(height: 16),
        FloatingActionButton.extended(
          heroTag: 'joinGroupBtn',
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.login),
          label: const Text('Unirse con Código'),
          onPressed: onJoinPressed,
        ),
      ],
    );
  }
}
