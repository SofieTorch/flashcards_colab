import 'package:flashcards_colab/models/models.dart';
import 'package:flashcards_colab/team/team.dart';
import 'package:flutter/material.dart';

class TeamListItem extends StatelessWidget {
  const TeamListItem(this.team, {Key? key}) : super(key: key);

  final Team team;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<Widget>(
          builder: (_) => TeamPage(team: team),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(team.name),
      ),
    );
  }
}
