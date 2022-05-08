import 'package:appwrite/appwrite.dart';
import 'package:flashcards_colab/authentication/bloc/authentication_bloc.dart';
import 'package:flashcards_colab/data/repositories/teams_repository.dart';
import 'package:flashcards_colab/join_team/join_team.dart';
import 'package:flashcards_colab/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinTeamPage extends StatelessWidget {
  const JoinTeamPage(this.membership, {Key? key}) : super(key: key);

  final Membership membership;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JoinTeamBloc>(
      create: (context) => JoinTeamBloc(
        membership: membership,
        teamsRepository: TeamsRepository(
          client: context.read<Client>(),
        ),
      )..add(const TeamRequested()),
      child: const _JoinTeamView(),
    );
  }
}

class _JoinTeamView extends StatelessWidget {
  const _JoinTeamView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<JoinTeamBloc, JoinTeamState>(
          listener: (context, state) {
            if (state.status == JoinTeamStatus.success) {
              context.read<AuthenticationBloc>().add(VerifyAuthRequested());
            }
          },
          builder: (context, state) {
            if (state.teamStatus == RetrieveTeamStatus.success) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${state.team.name} Team has invited you to join!'),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<JoinTeamBloc>()
                          .add(const TeamInvitationAccepted());
                    },
                    child: const Text('Join team!'),
                  ),
                ],
              );
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
