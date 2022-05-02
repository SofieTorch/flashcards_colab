import 'package:flashcards_colab/models/models.dart';
import 'package:flutter/material.dart';

class DeckListItem extends StatelessWidget {
  const DeckListItem(this.deck, {Key? key}) : super(key: key);

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(deck.title),
          Text(deck.cardsCount.toString()),
        ],
      ),
    );
  }
}
