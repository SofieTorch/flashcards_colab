import 'package:flashcards_colab/models/models.dart';
import 'package:flashcards_colab/team/team.dart';
import 'package:flashcards_colab/theme/theme.dart';
import 'package:flutter/material.dart';

class TeamListItem extends StatelessWidget {
  const TeamListItem(this.team, {Key? key}) : super(key: key);

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.snuff,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<Widget>(
            builder: (_) => TeamPage(team: team),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Team',
                      style: Theme.of(context).textTheme.overline,
                    ),
                    Text(
                      team.name,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      team.description,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Tooltip(
                  message: 'Members',
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Chip(
                      label: Text('${team.members}'),
                      backgroundColor: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
