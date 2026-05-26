import 'package:flutter/material.dart';

class EfficacyCard extends StatelessWidget {
  final double winRate;

  const EfficacyCard({
    Key? key,
    required this.winRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        gradient: LinearGradient(
          colors: winRate >= 50
              ? <Color>[Colors.orangeAccent, Colors.deepOrange]
              : <Color>[
                  Colors.blueGrey.shade400,
                  Colors.blueGrey.shade700,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 32.0,
          horizontal: 16.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.bolt,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              '${winRate.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Eficacia',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
