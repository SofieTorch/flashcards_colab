import 'package:appwrite/appwrite.dart';
import 'package:flashcards_colab/data/repositories/repositories.dart';
import 'package:flashcards_colab/decks/decks.dart';
import 'package:flashcards_colab/models/models.dart';
import 'package:flashcards_colab/team/team.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({
    required this.team,
    Key? key,
  }) : super(key: key);

  final Team team;

  @override
  Widget build(BuildContext context) {
    final client = context.read<Client>();
    final currentUser = context.read<AuthenticationRepository>().currentUser;
    return MultiBlocProvider(
      providers: [
        BlocProvider<TeamBloc>(
          create: (context) => TeamBloc(
            team: team,
            teamsRepository: TeamsRepository(
              client: client,
            ),
          ),
        ),
        BlocProvider(
          create: (context) => DecksBloc(
            teamId: team.id,
            decksRepository: DecksRepository(
              client: client,
              currentUser: currentUser,
            ),
          )
            ..add(DecksRequested())
            ..add(const SubscriptionRequested()),
        ),
      ],
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
      body: Column(
        children: const [
          Text('Decks:'),
          DeckList(),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: MdiIcons.plus,
        activeIcon: MdiIcons.close,
        spaceBetweenChildren: 8,
        children: [
          SpeedDialChild(
            elevation: 2.5,
            child: const Icon(MdiIcons.accountMultiplePlus),
            label: 'Add member',
            onTap: () => showDialog<void>(
              context: context,
              builder: (_) {
                return BlocProvider.value(
                  value: context.read<TeamBloc>(),
                  child: BlocListener<TeamBloc, TeamState>(
                    listenWhen: (previous, current) =>
                        previous.newMemberStatus != current.newMemberStatus,
                    listener: (context, state) {
                      if (state.newMemberStatus == NewMemberStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "The invitation was sent to the member's email!",
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const NewMemberDialog(),
                  ),
                );
              },
            ),
          ),
          SpeedDialChild(
            elevation: 2.5,
            child: const Icon(MdiIcons.cardMultiple),
            label: 'Create deck',
            onTap: () => showModalBottomSheet<Widget>(
              context: context,
              builder: (_) => BlocProvider<DecksBloc>.value(
                value: BlocProvider.of<DecksBloc>(context),
                child: BlocListener<DecksBloc, DecksState>(
                  listenWhen: (previous, current) =>
                      previous.newDeckStatus != current.newDeckStatus,
                  listener: (context, state) {
                    if (state.newDeckStatus == NewDeckStatus.success) {
                      Navigator.pop(context);
                    }
                  },
                  child: const BottomSheetNewDeck(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
