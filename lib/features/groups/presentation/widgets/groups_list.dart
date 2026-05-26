import 'package:flutter/material.dart';
import 'package:guess_it/features/groups/domain/entities/group_entity.dart';

class GroupsList extends StatelessWidget {
  final List<GroupEntity> groups;
  final Function(GroupEntity) onGroupTap;

  const GroupsList({
    Key? key,
    required this.groups,
    required this.onGroupTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(24.0),
      itemCount: groups.length,
      itemBuilder: (BuildContext context, int index) {
        final GroupEntity group = groups[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          color: Colors.white,
          child: ListTile(
            onTap: () {
              onGroupTap(group);
            },
            contentPadding: const EdgeInsets.all(16.0),
            title: Text(
              group.name,
              style: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            subtitle: Text(
              '${group.memberNames.length} miembros',
            ),
            trailing: Chip(
              label: Text(group.joinCode.toUpperCase()),
              backgroundColor: Colors.green,
            ),
          ),
        );
      },
    );
  }
}
