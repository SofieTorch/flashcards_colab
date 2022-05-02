import 'package:appwrite/appwrite.dart';
import 'package:flashcards_colab/data/repositories/authentication_repository.dart';
import 'package:flashcards_colab/data/repositories/decks_repository.dart';
import 'package:flashcards_colab/decks/decks.dart';
import 'package:flashcards_colab/decks/widgets/widgets.dart';
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
          awClient: context.read<Client>(),
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
    return Stack(
      children: [
        BlocBuilder<DecksBloc, DecksState>(
          builder: (context, state) {
            return state.status == DecksStatus.loading
                ? const CircularProgressIndicator()
                : ListView.builder(
                    itemCount: state.decks.length,
                    itemBuilder: (_, index) {
                      return DeckListItem(state.decks[index]);
                    },
                  );
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () => showModalBottomSheet<Widget>(
              context: context,
              builder: (_) => BlocProvider<DecksBloc>.value(
                value: BlocProvider.of<DecksBloc>(context),
                child: const BottomSheetNewDeck(),
              ),
            ),
            // onPressed: () => context.read<DecksBloc>()
            //   ..add(const NewDeckTitleChanged('title'))
            //   ..add(const NewDeckCreated()),
            child: const Icon(MdiIcons.plus),
          ),
        )
      ],
    );
  }
}
