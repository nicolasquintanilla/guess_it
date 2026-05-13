import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_it/features/groups/domain/repositories/group_repository.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_event.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_state.dart';
import 'package:guess_it/features/groups/domain/entities/group_entity.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository repository;

  GroupBloc({
    required GroupRepository repository,
  })  : repository = repository,
        super(const GroupState()) {
    on<LoadGroupsEvent>(_onLoadGroups);
    on<CreateGroupEvent>(_onCreateGroup);
    on<JoinGroupEvent>(_onJoinGroup);
    on<DeleteGroupEvent>(_onDeleteGroup);
    on<LeaveGroupEvent>(_onLeaveGroup);
    on<ClearGroupsEvent>(_onClearGroups);
    on<KickMemberEvent>(_onKickMember);
  }

  Future<void> _onLoadGroups(
    LoadGroupsEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(state.copyWith(status: GroupStatus.loading));
    try {
      final List<GroupEntity> groups = await repository.getUserGroups();
      emit(
        state.copyWith(
          status: GroupStatus.success,
          groups: groups,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GroupStatus.error,
          errorMessage: e.toString(),
          groups: const <GroupEntity>[],
        ),
      );
    }
  }

  Future<void> _onCreateGroup(
    CreateGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(state.copyWith(status: GroupStatus.loading));
    try {
      await repository.createGroup(event.groupName);
      add(const LoadGroupsEvent());
      emit(
        state.copyWith(
          status: GroupStatus.success,
          successMessage: '¡Grupo creado con éxito!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GroupStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onJoinGroup(
    JoinGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(state.copyWith(status: GroupStatus.loading));
    try {
      await repository.joinGroup(event.joinCode);
      add(const LoadGroupsEvent());
      emit(
        state.copyWith(
          status: GroupStatus.success,
          successMessage: '¡Te has unido al grupo!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GroupStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteGroup(
    DeleteGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(state.copyWith(status: GroupStatus.loading));
    try {
      await repository.deleteGroup(event.groupId);
      add(const LoadGroupsEvent());
      emit(
        state.copyWith(
          status: GroupStatus.success,
          successMessage: 'Grupo eliminado',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GroupStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLeaveGroup(
    LeaveGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(state.copyWith(status: GroupStatus.loading));
    try {
      await repository.leaveGroup(event.groupId);
      add(const LoadGroupsEvent());
      emit(
        state.copyWith(
          status: GroupStatus.success,
          successMessage: 'Has salido del grupo',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GroupStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onClearGroups(
    ClearGroupsEvent event,
    Emitter<GroupState> emit,
  ) {
    emit(const GroupState());
  }

  Future<void> _onKickMember(
    KickMemberEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(state.copyWith(status: GroupStatus.loading));
    try {
      await repository.kickMember(event.groupId, event.memberName, event.memberEmail);
      add(const LoadGroupsEvent()); // Recargamos para ver la lista actualizada
      emit(
        state.copyWith(
          status: GroupStatus.success,
          successMessage: 'Miembro expulsado del grupo.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GroupStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
