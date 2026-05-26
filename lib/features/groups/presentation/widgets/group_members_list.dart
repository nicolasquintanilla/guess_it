import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guess_it/features/groups/domain/entities/group_entity.dart';

class GroupMembersList extends StatelessWidget {
  final GroupEntity group;
  final bool isHost;
  final String? currentUserName;
  final Function(String name, String email) onExpel;

  const GroupMembersList({
    Key? key,
    required this.group,
    required this.isHost,
    this.currentUserName,
    required this.onExpel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Integrantes (${group.memberNames.length})',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: group.memberNames.length,
          itemBuilder: (BuildContext context, int index) {
            final String memberName = group.memberNames[index];
            final String memberEmail =
                (index < group.memberEmails.length)
                    ? group.memberEmails[index]
                    : '';

            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.purple,
                ),
                title: Text(
                  index == 0 ? '👑 $memberName' : memberName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                trailing:
                    (isHost && memberName != currentUserName)
                        ? IconButton(
                            icon: const Icon(
                              Icons.person_remove,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              showCupertinoDialog(
                                context: context,
                                builder: (BuildContext ctx) =>
                                    CupertinoAlertDialog(
                                      title: const Text(
                                        'Expulsar jugador',
                                      ),
                                      content: Text(
                                        '¿Seguro que quieres expulsar a $memberName del grupo?',
                                      ),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          child: const Text('Cancelar'),
                                          onPressed: () => Navigator.pop(ctx),
                                        ),
                                        CupertinoDialogAction(
                                          isDestructiveAction: true,
                                          child: const Text('Expulsar'),
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            onExpel(memberName, memberEmail);
                                          },
                                        ),
                                      ],
                                    ),
                              );
                            },
                          )
                        : null,
              ),
            );
          },
        ),
      ],
    );
  }
}
