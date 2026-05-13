import 'package:equatable/equatable.dart';

class GroupEntity extends Equatable {
  final String id;
  final String name;
  final String hostId;
  final String joinCode;
  final List<String> memberNames;
  final List<String> memberEmails;
  final String createdAt;
  final Map<String, int> scores;

  const GroupEntity({
    required this.id,
    required this.name,
    required this.hostId,
    required this.joinCode,
    required this.memberNames,
    required this.memberEmails,
    required this.createdAt,
    Map<String, int> scores = const <String, int>{},
  }) : scores = scores;

  GroupEntity copyWith({
    String? id,
    String? name,
    String? hostId,
    String? joinCode,
    List<String>? memberNames,
    List<String>? memberEmails,
    String? createdAt,
    Map<String, int>? scores,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      hostId: hostId ?? this.hostId,
      joinCode: joinCode ?? this.joinCode,
      memberNames: memberNames ?? this.memberNames,
      memberEmails: memberEmails ?? this.memberEmails,
      createdAt: createdAt ?? this.createdAt,
      scores: scores ?? this.scores,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        hostId,
        joinCode,
        memberNames,
        memberEmails,
        createdAt,
        scores,
      ];
}
