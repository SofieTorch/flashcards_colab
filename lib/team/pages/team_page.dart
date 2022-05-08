import 'package:appwrite/appwrite.dart';
import 'package:flashcards_colab/data/repositories/teams_repository.dart';
import 'package:flashcards_colab/models/models.dart';
import 'package:flashcards_colab/team/team.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({
    required this.team,
    Key? key,
  }) : super(key: key);

  final Team team;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeamBloc>(
      create: (context) => TeamBloc(
        team: team,
        teamsRepository: TeamsRepository(
          client: context.read<Client>(),
        ),
      ),
      child: const _TeamView(),
    );
  }
}

class _TeamView extends StatelessWidget {
  const _TeamView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<TeamBloc>()
          ..add(const NewMemberEmailChanged('soff.torch@gmail.com'))
          ..add(const NewMemberInvited()),
      ),
    );
  }
}
