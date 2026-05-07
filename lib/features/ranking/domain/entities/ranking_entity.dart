import 'package:equatable/equatable.dart';

class RankingEntity extends Equatable {
  final String hostName;
  final int totalMatchesWon;
  final int totalPointsScored;
  final int gamesPlayed;
  final int victories;

  const RankingEntity({
    required String hostName,
    required int totalMatchesWon,
    required int totalPointsScored,
    required int gamesPlayed,
    required int victories,
  })  : hostName = hostName,
        totalMatchesWon = totalMatchesWon,
        totalPointsScored = totalPointsScored,
        gamesPlayed = gamesPlayed,
        victories = victories;

  @override
  List<Object?> get props => <Object?>[
        hostName,
        totalMatchesWon,
        totalPointsScored,
        gamesPlayed,
        victories,
      ];
}
