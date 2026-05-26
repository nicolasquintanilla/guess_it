import 'package:equatable/equatable.dart';
import 'package:guess_it/features/groups/domain/entities/group_entity.dart';

/// Clase base para todos los eventos gestionados por el [GroupBloc].
abstract class GroupEvent extends Equatable {
  /// Constructor base.
  const GroupEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Evento que solicita la carga inicial del flujo (Stream) de grupos del usuario.
class LoadGroupsEvent extends GroupEvent {
  /// Constructor base.
  const LoadGroupsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Evento interno disparado cuando el repositorio emite una nueva lista de grupos.
class GroupsUpdatedEvent extends GroupEvent {
  /// La lista actualizada de grupos.
  final List<GroupEntity> groups;

  /// Crea un evento de actualización con la nueva lista [groups].
  const GroupsUpdatedEvent({required this.groups});

  @override
  List<Object?> get props => <Object?>[groups];
}

/// Evento que solicita la creación de un nuevo grupo en la base de datos.
class CreateGroupEvent extends GroupEvent {
  /// El nombre del nuevo grupo a crear.
  final String groupName;

  /// Crea el evento con el [groupName] proporcionado.
  const CreateGroupEvent({required String groupName}) : groupName = groupName;

  @override
  List<Object?> get props => <Object?>[groupName];
}

/// Evento que solicita unirse a un grupo existente mediante un código.
class JoinGroupEvent extends GroupEvent {
  /// El código de invitación de 6 caracteres.
  final String joinCode;

  /// Crea el evento con el [joinCode] proporcionado.
  const JoinGroupEvent({required String joinCode}) : joinCode = joinCode;

  @override
  List<Object?> get props => <Object?>[joinCode];
}

/// Evento que solicita eliminar un grupo por completo (Solo anfitriones).
class DeleteGroupEvent extends GroupEvent {
  /// El identificador del grupo a eliminar.
  final String groupId;

  /// Crea el evento.
  const DeleteGroupEvent({required this.groupId});
  @override
  List<Object?> get props => <Object?>[groupId];
}

/// Evento que solicita abandonar un grupo (Solo miembros).
class LeaveGroupEvent extends GroupEvent {
  /// El identificador del grupo a abandonar.
  final String groupId;

  /// Crea el evento.
  const LeaveGroupEvent({required this.groupId});
  @override
  List<Object?> get props => <Object?>[groupId];
}

/// Evento que limpia el estado de los grupos (usualmente al cerrar sesión).
class ClearGroupsEvent extends GroupEvent {
  /// Constructor base.
  const ClearGroupsEvent();
}

/// Evento que solicita expulsar a un integrante del grupo (Solo anfitriones).
class KickMemberEvent extends GroupEvent {
  /// El identificador del grupo.
  final String groupId;

  /// El nombre del usuario a expulsar.
  final String memberName;

  /// El correo del usuario a expulsar.
  final String memberEmail;

  /// Crea el evento.
  const KickMemberEvent({
    required this.groupId,
    required this.memberName,
    required this.memberEmail,
  });

  @override
  List<Object?> get props => <Object?>[groupId, memberName, memberEmail];
}
