import 'package:equatable/equatable.dart';

class TeamEntity extends Equatable {
  final String name;
  final int score;

  const TeamEntity({
    required String name,
    required int score,
  })  : name = name,
        score = score;

  TeamEntity copyWith({
    String? name,
    int? score,
  }) {
    return TeamEntity(
      name: name ?? this.name,
      score: score ?? this.score,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        name,
        score,
      ];
}
