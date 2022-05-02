import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:flashcards_colab/data/providers/flashcards_provider.dart';
import 'package:flashcards_colab/data/providers/recalls_provider.dart';
import 'package:flashcards_colab/models/models.dart';

class FlashcardsRepository {
  FlashcardsRepository({
    required this.client,
    this.currentUser,
  })  : database = Database(client),
        flashcardsProvider = FlashcardsProvider(client),
        recallsProvider = RecallsProvider(client);

  final Client client;
  final Database database;
  final FutureOr<User>? currentUser;
  final FlashcardsProvider flashcardsProvider;
  final RecallsProvider recallsProvider;

  Future<void> createPersonalFlashcard(Flashcard flashcard) async {
    final flashcardDoc = await flashcardsProvider.createFlashcard(
      front: flashcard.front,
      back: flashcard.back,
      deckId: flashcard.deckId,
      permissions: ['user:${(await currentUser)?.id}'],
    );

    await recallsProvider.create(
      flashcardDoc.$id,
      (await currentUser)!.id,
    );
  }

  Future<List<Flashcard>> getFlashcards(Deck deck) async {
    final flashcards = <Flashcard>[];
    final docs = await flashcardsProvider.getFlashcards(deck.id);

    for (final doc in docs) {
      final recallDoc = await recallsProvider.getRecall(doc.$id);
      final flashcard = doc.toFlashcard.copyWith(
        recall: recallDoc.toRecall,
      );

      flashcards.add(flashcard);
    }

    return flashcards;
  }
}

extension on appwrite_models.Document {
  Flashcard get toFlashcard {
    return Flashcard(
      id: $id,
      deckId: data['deck_id'] as String,
      front: data['front_content'] as String,
      back: data['back_content'] as String,
    );
  }

  Recall get toRecall {
    return Recall(
      id: $id,
      flashcardId: data['flashcard_id'] as String,
      nextRepetition:
          DateTime.fromMillisecondsSinceEpoch(data['next_repetition'] as int),
      lastDifferenceHours: data['last_difference_hours'] as int,
    );
  }
}
