import 'package:flutter/material.dart';

class RoomCodeInput extends StatelessWidget {
  final TextEditingController controller;

  const RoomCodeInput({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.characters,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        letterSpacing: 4,
        color: Colors.white,
      ),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'CÓDIGO',
        hintStyle: TextStyle(color: Colors.white54),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}
