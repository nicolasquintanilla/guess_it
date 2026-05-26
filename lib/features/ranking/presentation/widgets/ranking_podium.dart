import 'package:flutter/material.dart';
import 'package:guess_it/features/ranking/domain/entities/ranking_entity.dart';

/// Widget de presentación gráfica que dibuja un podio (1º, 2º y 3º puesto)
/// para los mejores jugadores del ranking.
///
/// Los tres jugadores principales se resaltan con tamaños y bordes dorados,
/// plateados y cobrizos, destacándolos del resto de la lista.
class RankingPodium extends StatelessWidget {
  /// Lista con los datos de hasta los 3 mejores jugadores.
  final List<RankingEntity> top3;

  /// Diccionario con las rutas locales de los avatares para resolver la imagen.
  final Map<String, String> avatars;

  /// Crea una instancia de [RankingPodium].
  ///
  /// @param key El identificador opcional para el widget.
  /// @param top3 La sublista con los líderes de la clasificación.
  /// @param avatars Mapa inyectado para cargar los gráficos de los avatares.
  const RankingPodium({
    Key? key,
    required this.top3,
    required this.avatars,
  }) : super(key: key);

  Widget _buildPodiumAvatar(RankingEntity user, int rank) {
    final String avatarKey = user.avatar;
    final bool isSimple =
        avatarKey == 'none' || !avatars.containsKey(avatarKey);

    final bool isFirst = rank == 1;
    final double size = isFirst ? 110.0 : 85.0;

    Color podiumColor;
    if (rank == 1) {
      podiumColor = const Color(0xFFFFD700); // Oro
    } else if (rank == 2) {
      podiumColor = const Color(0xFFC0C0C0); // Plata
    } else {
      podiumColor = const Color(0xFFCD7F32); // Bronce
    }

    final Widget avatarWidget = isSimple
        ? Icon(Icons.person_pin, color: Colors.grey, size: size * 0.6)
        : Image.asset(
            avatars[avatarKey]!,
            width: size * 0.7,
            height: size * 0.7,
            fit: BoxFit.contain,
          );

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                    color: podiumColor,
                    width: isFirst ? 4 : 3,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: podiumColor.withOpacity(0.5),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(child: avatarWidget),
              ),
              Positioned(
                bottom: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: podiumColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '#$rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.hostName,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isFirst ? FontWeight.w900 : FontWeight.bold,
            fontSize: isFirst ? 20 : 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          '${user.victories} Victorias',
          style: TextStyle(color: Colors.white70, fontSize: isFirst ? 14 : 12),
        ),
      ],
    );
  }

  /// Construye el podio organizando visualmente los elementos en la disposición clásica (2º, 1º, 3º).
  ///
  /// @param context El contexto de construcción actual.
  /// @return Un [Widget] de tipo `Row` que contiene los avatares posicionados, o un contenedor vacío si la lista está vacía.
  @override
  Widget build(BuildContext context) {
    if (top3.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 240,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (top3.length >= 2)
              Expanded(child: _buildPodiumAvatar(top3[1], 2)),
            if (top3.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: _buildPodiumAvatar(top3[0], 1),
                ),
              ),
            if (top3.length >= 3)
              Expanded(child: _buildPodiumAvatar(top3[2], 3))
            else if (top3.length == 2)
              const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
