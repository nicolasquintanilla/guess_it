import 'package:flutter/material.dart';
import 'package:guess_it/features/game/domain/entities/team_entity.dart';

class RunnerUpTeamCard extends StatelessWidget {
  final TeamEntity team;
  final int rank;

  const RunnerUpTeamCard({
    Key? key,
    required this.team,
    required this.rank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 8.0,
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: Text(
            '#$rank',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        title: Text(
          team.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        trailing: Text(
          '${team.score} pts',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
