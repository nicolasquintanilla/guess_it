import 'package:flutter/material.dart';

class RoomCodeDisplay extends StatelessWidget {
  final String roomId;

  const RoomCodeDisplay({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Código de la sala:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            roomId,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              letterSpacing: 8,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
