import 'package:flutter/material.dart';

class GroupRankingPlaceholder extends StatelessWidget {
  const GroupRankingPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Ranking del Grupo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.purpleAccent.withOpacity(0.3), width: 1),
          ),
          child: const Column(
            children: <Widget>[
              Icon(
                Icons.construction_rounded,
                size: 48,
                color: Colors.purpleAccent,
              ),
              SizedBox(height: 16),
              Text(
                '¡Próximamente!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'El ranking interno de los grupos estará disponible en la próxima actualización.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
