import 'package:flashcards_colab/deck/deck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardList extends StatelessWidget {
  const FlashcardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeckBloc, DeckState>(
      builder: (context, state) {
        switch (state.status) {
          case FlashcardsStatus.failure:
            return const Center(child: Text('Failed to fetch flashcards'));
          case FlashcardsStatus.success:
            if (state.deck.flashcards.isEmpty) {
              return const Center(child: Text('Without flashcards yet'));
            }
            return ListView.builder(
              itemCount: state.deck.flashcards.length,
              itemBuilder: (_, index) {
                return FlashcardListItem(state.deck.flashcards[index]);
              },
            );
          // ignore: no_default_cases
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
