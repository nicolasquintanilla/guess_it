import 'package:equatable/equatable.dart';

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

class CreateGroupEvent extends GroupEvent {
  final String groupName;

  const CreateGroupEvent({
    required String groupName,
  }) : groupName = groupName;

  @override
  List<Object?> get props => <Object?>[groupName];
}

class JoinGroupEvent extends GroupEvent {
  final String joinCode;

  const JoinGroupEvent({
    required String joinCode,
  }) : joinCode = joinCode;

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
