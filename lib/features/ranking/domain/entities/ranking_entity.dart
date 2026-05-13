import 'package:equatable/equatable.dart';

class RankingEntity extends Equatable {
  final String hostName;
  final String avatar;
  final int totalMatchesWon;
  final int totalPointsScored;
  final int gamesPlayed;
  final int victories;

  const RankingEntity({
    required this.hostName,
    this.avatar = 'default',
    required this.totalMatchesWon,
    required this.totalPointsScored,
    required this.gamesPlayed,
    required this.victories,
  });

  // Fórmula Anti-Trampas: Eficacia penaliza a los que se dejan ganar.
  double get winRate => gamesPlayed > 0 ? (victories / gamesPlayed) : 0.0;
  double get rankScore => (victories * winRate * 100) + (totalPointsScored * 0.1);

  @override
  List<Object?> get props => <Object?>[hostName, avatar, totalMatchesWon, totalPointsScored, gamesPlayed, victories];
}
