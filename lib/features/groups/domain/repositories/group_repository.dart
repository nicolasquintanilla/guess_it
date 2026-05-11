import '../entities/group_entity.dart';

abstract class GroupRepository {
  Future<String> createGroup(String groupName);
  Future<void> joinGroup(String joinCode);
  Future<List<GroupEntity>> getUserGroups();
}
