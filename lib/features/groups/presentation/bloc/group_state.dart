import 'package:equatable/equatable.dart';
import 'package:guess_it/features/groups/domain/entities/group_entity.dart';

enum GroupStatus { initial, loading, success, error }

class GroupState extends Equatable {
  final GroupStatus status;
  final String? errorMessage;
  final String? successMessage;
  final List<GroupEntity> groups;

  const GroupState({
    GroupStatus status = GroupStatus.initial,
    String? errorMessage,
    String? successMessage,
    List<GroupEntity> groups = const <GroupEntity>[],
  })  : status = status,
        errorMessage = errorMessage,
        successMessage = successMessage,
        groups = groups;

  GroupState copyWith({
    GroupStatus? status,
    String? errorMessage,
    String? successMessage,
    List<GroupEntity>? groups,
  }) {
    return GroupState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      groups: groups ?? this.groups,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, errorMessage, successMessage, groups];
}
