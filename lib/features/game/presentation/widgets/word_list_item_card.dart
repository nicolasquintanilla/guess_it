import 'package:flutter/material.dart';

class WordListItemCard extends StatelessWidget {
  final String word;
  final bool isObscured;
  final VoidCallback onToggleVisibility;
  final VoidCallback onDelete;

  const WordListItemCard({
    Key? key,
    required this.word,
    required this.isObscured,
    required this.onToggleVisibility,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          isObscured ? '••••••' : word,
          style: const TextStyle(
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(
                isObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.purple,
              ),
              tooltip: isObscured ? 'Mostrar' : 'Ocultar',
              onPressed: onToggleVisibility,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Eliminar',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
