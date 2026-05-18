import 'package:equatable/equatable.dart';
import 'package:guess_it/features/groups/domain/entities/group_entity.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoadGroupsEvent extends GroupEvent {
  const LoadGroupsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class GroupsUpdatedEvent extends GroupEvent {
  final List<GroupEntity> groups;

  const GroupsUpdatedEvent({required this.groups});

  @override
  List<Object?> get props => <Object?>[groups];
}

class CreateGroupEvent extends GroupEvent {
  final String groupName;

  const CreateGroupEvent({required String groupName}) : groupName = groupName;

  @override
  List<Object?> get props => <Object?>[groupName];
}

class JoinGroupEvent extends GroupEvent {
  final String joinCode;

  const JoinGroupEvent({required String joinCode}) : joinCode = joinCode;

  @override
  List<Object?> get props => <Object?>[joinCode];
}

class DeleteGroupEvent extends GroupEvent {
  final String groupId;
  const DeleteGroupEvent({required this.groupId});
  @override
  List<Object?> get props => <Object?>[groupId];
}

class LeaveGroupEvent extends GroupEvent {
  final String groupId;
  const LeaveGroupEvent({required this.groupId});
  @override
  List<Object?> get props => <Object?>[groupId];
}

class ClearGroupsEvent extends GroupEvent {
  const ClearGroupsEvent();
}

class KickMemberEvent extends GroupEvent {
  final String groupId;
  final String memberName;
  final String memberEmail;

  const KickMemberEvent({
    required this.groupId,
    required this.memberName,
    required this.memberEmail,
  });

  @override
  List<Object?> get props => <Object?>[groupId, memberName, memberEmail];
}
