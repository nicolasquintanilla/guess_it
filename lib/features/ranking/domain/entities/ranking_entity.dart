import 'package:equatable/equatable.dart';

class RankingEntity extends Equatable {
  final String hostName;
  final int totalMatchesWon;
  final int totalPointsScored;

  const RankingEntity({
    required String hostName,
    required int totalMatchesWon,
    required int totalPointsScored,
  })  : hostName = hostName,
        totalMatchesWon = totalMatchesWon,
        totalPointsScored = totalPointsScored;

  @override
  List<Object?> get props => <Object?>[
        hostName,
        totalMatchesWon,
        totalPointsScored,
      ];
}
