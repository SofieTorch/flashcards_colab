import 'package:flashcards_colab/deck/pages/deck_page.dart';
import 'package:flashcards_colab/models/models.dart';
import 'package:flutter/material.dart';

class DeckListItem extends StatelessWidget {
  const DeckListItem(this.deck, {Key? key}) : super(key: key);

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(
        Radius.circular(8),
      ),
      color: const Color(0xFFd4d8f0),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<DeckPage>(
            builder: (context) => DeckPage(deck),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  deck.title,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    deck.cardsCount.toString(),
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    'Cards',
                    style: Theme.of(context).textTheme.overline,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
