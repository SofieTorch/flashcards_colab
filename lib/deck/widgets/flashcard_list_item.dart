import 'package:flashcards_colab/models/models.dart';
import 'package:flutter/material.dart';

class FlashcardListItem extends StatelessWidget {
  const FlashcardListItem(this.flashcard, {Key? key}) : super(key: key);
  final Flashcard flashcard;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(flashcard.front),
    );
  }
}
