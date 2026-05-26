import 'package:guess_it/features/ranking/domain/entities/ranking_entity.dart';

/// Contrato abstracto para el repositorio de clasificaciones.
///
/// Permite registrar los resultados al finalizar una partida y recuperar
/// la lista ordenada de los mejores jugadores.
abstract class RankingRepository {
  /// Registra el rendimiento de una partida finalizada para el usuario actual.
  ///
  /// Actualiza en la base de datos sus estadísticas (puntos totales, partidas jugadas
  /// y si ha sumado una victoria).
  ///
  /// @param points La cantidad de puntos obtenidos en la partida.
  /// @param isVictory `true` si el equipo del usuario ganó la partida, `false` en caso contrario.
  /// @return Un [Future] que se completa cuando la actualización es exitosa.
  Future<void> addWinAndPoints({required int points, required bool isVictory});

  /// Obtiene la clasificación global de todos los jugadores registrados.
  ///
  /// Extrae la lista, calcula sus puntuaciones de ranking y las ordena
  /// de mayor a menor puntuación.
  ///
  /// @return Un [Future] que contiene la lista de los jugadores ordenados como [RankingEntity].
  Future<List<RankingEntity>> getGlobalRanking();
}
