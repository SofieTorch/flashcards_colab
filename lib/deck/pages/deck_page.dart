import 'package:appwrite/appwrite.dart';
import 'package:flashcards_colab/data/repositories/authentication_repository.dart';
import 'package:flashcards_colab/data/repositories/flashcards_repository.dart';
import 'package:flashcards_colab/deck/deck.dart';
import 'package:flashcards_colab/flashcard/pages/create_flashcard_page.dart';
import 'package:flashcards_colab/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DeckPage extends StatelessWidget {
  const DeckPage(this.deck, {Key? key}) : super(key: key);
  final Deck deck;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeckBloc>(
      create: (context) => DeckBloc(
        deck: deck,
        flashcardsRepository: FlashcardsRepository(
          client: context.read<Client>(),
          currentUser: context.read<AuthenticationRepository>().currentUser,
        ),
      )..add(FlashcardsRequested()),
      child: const _DeckView(),
    );
  }
}

class _DeckView extends StatelessWidget {
  const _DeckView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deck = context.select<DeckBloc, Deck>((value) => value.state.deck);
    return Scaffold(
      appBar: AppBar(
        title: Text(deck.title),
      ),
      body: const FlashcardList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<CreateFlashcardPage>(
            builder: (context) => CreateFlashcardPage(deckId: deck.id),
          ),
        ),
        child: const Icon(MdiIcons.plus),
      ),
    );
  }
}
