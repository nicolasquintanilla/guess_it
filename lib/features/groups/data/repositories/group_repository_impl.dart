import 'package:guess_it/features/groups/domain/entities/group_entity.dart';
import 'package:guess_it/features/groups/domain/repositories/group_repository.dart';
import 'package:guess_it/features/groups/data/datasources/group_remote_data_source.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource remoteDataSource;

  const GroupRepositoryImpl({
    required GroupRemoteDataSource remoteDataSource,
  }) : remoteDataSource = remoteDataSource;

  @override
  Future<String> createGroup(String groupName) async {
    return await remoteDataSource.createGroup(groupName);
  }

  @override
  Future<void> joinGroup(String joinCode) async {
    return await remoteDataSource.joinGroup(joinCode);
  }

  @override
  Future<List<GroupEntity>> getUserGroups() async {
    return await remoteDataSource.getUserGroups();
  }
}
