import 'package:flutter/material.dart';

/// Widget tipo tarjeta (Card) diseñado para mostrar el porcentaje de victorias del usuario.
///
/// Destaca visualmente cambiando su esquema de color (degradado) dependiendo
/// de si la tasa de victorias ([winRate]) es superior o igual al 50%.
class EfficacyCard extends StatelessWidget {
  /// El porcentaje de victorias del usuario, de 0.0 a 100.0.
  final double winRate;

  /// Crea una instancia de [EfficacyCard].
  ///
  /// @param key El identificador opcional para el widget.
  /// @param winRate La tasa de victorias a renderizar.
  const EfficacyCard({
    Key? key,
    required this.winRate,
  }) : super(key: key);

  /// Construye la representación gráfica de la tarjeta de eficacia.
  ///
  /// @param context El contexto de construcción actual.
  /// @return Un [Widget] de tipo contenedor con colores condicionales y sombra.
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
