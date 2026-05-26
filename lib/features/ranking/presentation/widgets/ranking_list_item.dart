import 'package:flutter/material.dart';
import 'package:guess_it/features/ranking/domain/entities/ranking_entity.dart';

/// Widget de interfaz que representa a un usuario individual dentro de la lista de ranking.
///
/// Muestra su posición, avatar, nombre y estadísticas clave (victorias).
/// Se utiliza para los jugadores que están fuera del podio (posiciones 4 en adelante).
class RankingListItem extends StatelessWidget {
  /// Entidad con los datos estadísticos y perfil del usuario.
  final RankingEntity user;

  /// La posición actual de este usuario en la clasificación (ej. 4, 5, 6...).
  final int rank;

  /// Diccionario con las rutas locales de los avatares disponibles.
  final Map<String, String> avatars;

  /// Crea una instancia de [RankingListItem].
  ///
  /// @param key El identificador opcional para el widget.
  /// @param user La entidad [RankingEntity] a mostrar.
  /// @param rank El número de puesto en la clasificación general.
  /// @param avatars Mapa inyectado para la resolución gráfica del avatar.
  const RankingListItem({
    Key? key,
    required this.user,
    required this.rank,
    required this.avatars,
  }) : super(key: key);

  /// Construye la representación gráfica en forma de tarjeta (`Card`) y `ListTile`.
  ///
  /// @param context El contexto de construcción actual.
  /// @return Un [Widget] visualizando la fila de la tabla de clasificación.
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '#$rank',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              decoration: null,
              child: Center(
                child: (user.avatar == 'none' ||
                        !avatars.containsKey(user.avatar))
                    ? const Icon(
                        Icons.person_pin,
                        color: Colors.grey,
                        size: 32,
                      )
                    : Image.asset(
                        avatars[user.avatar]!,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ],
        ),
        title: Text(
          user.hostName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              '${user.victories} Victorias',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.deepPurple,
              ),
            ),
            if (rank < 4)
              Text(
                '${user.totalPointsScored} pts',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
