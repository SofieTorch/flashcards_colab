import 'package:appwrite/appwrite.dart';
import 'package:flashcards_colab/data/repositories/repositories.dart';
import 'package:flashcards_colab/decks/decks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DecksPage extends StatelessWidget {
  const DecksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DecksBloc(
        decksRepository: DecksRepository(
          client: context.read<Client>(),
          currentUser: context.read<AuthenticationRepository>().currentUser,
        ),
      )..add(DecksRequested()),
      child: const _DecksView(),
    );
  }
}

class _DecksView extends StatelessWidget {
  const _DecksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Stack(
        children: [
          const DeckList(),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () => showModalBottomSheet<Widget>(
                context: context,
                isScrollControlled: true,
                builder: (_) => BlocProvider<DecksBloc>.value(
                  value: BlocProvider.of<DecksBloc>(context),
                  child: BlocListener<DecksBloc, DecksState>(
                    listenWhen: (previous, current) =>
                        previous.newDeckStatus != current.newDeckStatus,
                    listener: (context, state) {
                      if (state.newDeckStatus == NewDeckStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Deck created!'),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const BottomSheetNewDeck(),
                  ),
                ),
              ),
              child: const Icon(MdiIcons.plus),
            ),
          )
        ],
      ),
    );
  }
}
