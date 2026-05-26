import 'package:flutter/material.dart';

class WordInputRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const WordInputRow({
    Key? key,
    required this.controller,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Nueva palabra',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (String _) {
              onAdd();
            },
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.add, size: 32),
          onPressed: onAdd,
          color: Colors.blueAccent,
        ),
      ],
    );
  }
}
