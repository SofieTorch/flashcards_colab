import 'package:appwrite/appwrite.dart';
import 'package:flashcards_colab/data/repositories/teams_repository.dart';
import 'package:flashcards_colab/teams/teams.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TeamsPage extends StatelessWidget {
  const TeamsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeamListBloc>(
      create: (context) => TeamListBloc(
        teamsRepository: TeamsRepository(
          client: context.read<Client>(),
        ),
      )..add(const TeamListRequested()),
      child: const _TeamsView(),
    );
  }
}

class _TeamsView extends StatelessWidget {
  const _TeamsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamListBloc, TeamListState>(
      builder: (context, state) {
        if (state.status == TeamListStatus.failure) {
          return const Center(
            child: Text('Teams could not be retrieved, retry later'),
          );
        }
        if (state.status == TeamListStatus.success) {
          return Stack(
            children: [
              if (state.teams.isEmpty)
                const Center(
                  child: Text('No teams yet'),
                )
              else
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.teams.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: TeamListItem(state.teams[index]),
                    );
                  },
                ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  onPressed: () => showModalBottomSheet<Widget>(
                    isScrollControlled: true,
                    context: context,
                    builder: (_) => BlocProvider<TeamListBloc>.value(
                      value: BlocProvider.of<TeamListBloc>(context),
                      child: BlocListener<TeamListBloc, TeamListState>(
                        listenWhen: (previous, current) =>
                            previous.newTeamStatus != current.newTeamStatus,
                        listener: (context, state) {
                          if (state.newTeamStatus == NewTeamStatus.success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Team created!')),
                            );
                            Navigator.of(context).pop();
                          }
                        },
                        child: const BottomSheetNewTeam(),
                      ),
                    ),
                  ),
                  child: const Icon(MdiIcons.plus),
                ),
              ),
            ],
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
