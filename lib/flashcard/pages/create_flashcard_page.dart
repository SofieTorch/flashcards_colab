import 'package:appwrite/appwrite.dart';
import 'package:flashcards_colab/data/repositories/authentication_repository.dart';
import 'package:flashcards_colab/data/repositories/flashcards_repository.dart';
import 'package:flashcards_colab/deck/deck.dart';
import 'package:flashcards_colab/flashcard/flashcard.dart';
import 'package:flashcards_colab/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateFlashcardPage extends StatelessWidget {
  CreateFlashcardPage({String? deckId, Flashcard? flashcard, Key? key})
      : _flashcard = flashcard ?? Flashcard(deckId: deckId!),
        super(key: key);

  final Flashcard _flashcard;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FlashcardBloc>(
      create: (context) => FlashcardBloc(
        flashcard: _flashcard,
        flashcardsRepository: FlashcardsRepository(
          client: context.read<Client>(),
          currentUser: context.read<AuthenticationRepository>().currentUser,
        ),
      ),
      child: const _CreateFlashcardView(),
    );
  }
}

class _CreateFlashcardView extends StatelessWidget {
  const _CreateFlashcardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          FlashcardForm(),
          _CreateButton(),
        ],
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeckBloc, DeckState>(
      builder: (context, state) {
        if (state.newFlashcardStatus == NewFlashcardStatus.inProgress) {
          return const CircularProgressIndicator();
        }
        final flashcard = context.select<FlashcardBloc, Flashcard>(
          (value) => value.state.flashcard,
        );
        return ElevatedButton(
          onPressed: () =>
              context.read<DeckBloc>().add(FlashcardCreated(flashcard)),
          child: const Text('Create'),
        );
      },
    );
  }
}
