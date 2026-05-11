import 'package:equatable/equatable.dart';

class GroupEntity extends Equatable {
  final String id;
  final String name;
  final String hostId;
  final String joinCode;
  final List<String> memberNames;
  final String createdAt;

  const GroupEntity({
    required this.id,
    required this.name,
    required this.hostId,
    required this.joinCode,
    required this.memberNames,
    required this.createdAt,
  });

  GroupEntity copyWith({
    String? id,
    String? name,
    String? hostId,
    String? joinCode,
    List<String>? memberNames,
    String? createdAt,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      hostId: hostId ?? this.hostId,
      joinCode: joinCode ?? this.joinCode,
      memberNames: memberNames ?? this.memberNames,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        hostId,
        joinCode,
        memberNames,
        createdAt,
      ];
}
