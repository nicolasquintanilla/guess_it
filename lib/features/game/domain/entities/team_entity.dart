import 'package:equatable/equatable.dart';

class TeamEntity extends Equatable {
  final String name;
  final int score;

  final List<String> registeredEmails;

  const TeamEntity({
    required String name,
    required int score,
    List<String> registeredEmails = const <String>[],
  })  : name = name,
        score = score,
        registeredEmails = registeredEmails;

  TeamEntity copyWith({
    String? name,
    int? score,
    List<String>? registeredEmails,
  }) {
    return TeamEntity(
      name: name ?? this.name,
      score: score ?? this.score,
      registeredEmails: registeredEmails ?? this.registeredEmails,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        name,
        score,
        registeredEmails,
      ];
}
