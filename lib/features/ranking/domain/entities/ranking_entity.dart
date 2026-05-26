import 'package:equatable/equatable.dart';

/// Representa el rendimiento histórico de un usuario dentro del sistema de clasificación.
///
/// Contiene las métricas necesarias para calcular la eficacia y el puesto
/// en el ranking (victorias, partidas jugadas, puntos totales).
class RankingEntity extends Equatable {
  /// Nombre de visualización del usuario.
  final String hostName;

  /// Clave del avatar seleccionado por el usuario.
  final String avatar;

  /// Suma de todas las partidas ganadas históricamente.
  final int totalMatchesWon;

  /// Puntos acumulados en todas sus participaciones.
  final int totalPointsScored;

  /// Total de partidas en las que ha participado.
  final int gamesPlayed;

  /// Total de victorias absolutas (sinónimo usado para cálculos de ranking).
  final int victories;

  /// Crea una instancia de [RankingEntity].
  ///
  /// @param hostName Nombre del usuario.
  /// @param avatar Identificador del avatar (por defecto 'default').
  /// @param totalMatchesWon Victorias totales.
  /// @param totalPointsScored Puntos totales acumulados.
  /// @param gamesPlayed Partidas jugadas.
  /// @param victories Victorias individuales.
  const RankingEntity({
    required this.hostName,
    this.avatar = 'default',
    required this.totalMatchesWon,
    required this.totalPointsScored,
    required this.gamesPlayed,
    required this.victories,
  });

  /// Calcula la tasa de victoria (eficacia) como un valor de 0.0 a 1.0.
  double get winRate => gamesPlayed > 0 ? (victories / gamesPlayed) : 0.0;

  /// Fórmula ponderada para determinar la posición exacta en el ranking.
  ///
  /// Combina la eficacia, el número de victorias y los puntos anotados.
  double get rankScore => (victories * winRate * 100) + (totalPointsScored * 0.1);

  @override
  List<Object?> get props => <Object?>[hostName, avatar, totalMatchesWon, totalPointsScored, gamesPlayed, victories];
}
