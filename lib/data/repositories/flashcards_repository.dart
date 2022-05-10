import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appw_models;
import 'package:flashcards_colab/data/providers/flashcards_provider.dart';
import 'package:flashcards_colab/data/providers/recalls_provider.dart';
import 'package:flashcards_colab/models/models.dart';

class FlashcardsRepository {
  FlashcardsRepository({
    required Client client,
    this.currentUser,
  })  : _flashcardsProvider = FlashcardsProvider(client),
        _recallsProvider = RecallsProvider(client);

  final FutureOr<User>? currentUser;
  final FlashcardsProvider _flashcardsProvider;
  final RecallsProvider _recallsProvider;
  final _controller = StreamController<Flashcard>();

  Stream<Flashcard> get flashcardsStream async* {
    yield* _controller.stream;
  }

  void subscribeToFlashcards({required String deckId}) {
    _flashcardsProvider.subscribeToDeckFlashcards(
      deckId: deckId,
      onData: (realtimeMessage) async {
        final flashcardDoc = realtimeMessage.toFlashcardDocument;
        final recallDoc = await _recallsProvider.getRecall(flashcardDoc.$id);
        final flashcard = flashcardDoc.toFlashcard.copyWith(
          recall: recallDoc.toRecall,
        );

        _controller.add(flashcard);
      },
    );
  }

  Future<void> createPersonalFlashcard(Flashcard flashcard) async {
    final flashcardDoc = await _flashcardsProvider.createFlashcard(
      front: flashcard.front,
      back: flashcard.back,
      deckId: flashcard.deckId,
      permissions: ['user:${(await currentUser)?.id}'],
    );

    await _recallsProvider.create(
      flashcardDoc.$id,
      (await currentUser)!.id,
    );
  }

  Future<List<Flashcard>> getFlashcards(Deck deck) async {
    final flashcards = <Flashcard>[];
    final docs = await _flashcardsProvider.getFlashcards(deck.id);

    for (final doc in docs) {
      final recallDoc = await _recallsProvider.getRecall(doc.$id);
      final flashcard = doc.toFlashcard.copyWith(
        recall: recallDoc.toRecall,
      );

      flashcards.add(flashcard);
    }

    return flashcards;
  }

  void dispose() {
    _controller.close();
    _flashcardsProvider.dispose();
  }
}

extension on appw_models.Document {
  Flashcard get toFlashcard {
    return Flashcard(
      id: $id,
      deckId: data['deck'] as String,
      front: data['front_content'] as String,
      back: data['back_content'] as String,
    );
  }

  Recall get toRecall {
    return Recall(
      id: $id,
      flashcardId: data['flashcard'] as String,
      nextRepetition:
          DateTime.fromMillisecondsSinceEpoch(data['next_repetition'] as int),
      lastDifferenceHours: data['last_hours_interval'] as int,
    );
  }
}

extension on RealtimeMessage {
  appw_models.Document get toFlashcardDocument {
    final readRaw = payload['\$read'] as List<dynamic>;
    final readPermissions = readRaw.map((dynamic e) => e.toString()).toList();
    final writeRaw = payload['\$read'] as List<dynamic>;
    final writePermissions = writeRaw.map((dynamic e) => e.toString()).toList();

    return appw_models.Document(
      $id: payload['\$id'] as String,
      $collection: payload['\$collection'] as String,
      $read: readPermissions,
      $write: writePermissions,
      data: <String, dynamic>{
        'deck': payload['deck'],
        'front_content': payload['front_content'],
        'type': payload['type'],
        'back_content': payload['back_content'],
      },
    );
  }
}
