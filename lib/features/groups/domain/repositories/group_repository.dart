import '../entities/group_entity.dart';

abstract class GroupRepository {
  Future<String> createGroup(String groupName);
  Future<void> joinGroup(String joinCode);
  Future<List<GroupEntity>> getUserGroups();
  Future<void> deleteGroup(String groupId);
  Future<void> leaveGroup(String groupId);
  Future<void> kickMember(String groupId, String memberName, String memberEmail);
}
