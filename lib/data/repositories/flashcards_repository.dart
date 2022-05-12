// ignore_for_file: use_raw_strings

import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appw_models;
import 'package:flashcards_colab/data/providers/flashcards_provider.dart';
import 'package:flashcards_colab/data/providers/recalls_provider.dart';
import 'package:flashcards_colab/data/providers/teams_provider.dart';
import 'package:flashcards_colab/models/models.dart';

class FlashcardsRepository {
  FlashcardsRepository({
    required Client client,
    this.currentUser,
  })  : _flashcardsProvider = FlashcardsProvider(client),
        _recallsProvider = RecallsProvider(client),
        _teamsProvider = TeamsProvider(client: client);

  final FutureOr<User>? currentUser;
  final FlashcardsProvider _flashcardsProvider;
  final RecallsProvider _recallsProvider;
  final TeamsProvider _teamsProvider;
  final _controller = StreamController<Flashcard>();

  Stream<Flashcard> get flashcardsStream async* {
    yield* _controller.stream;
  }

  Future<void> subscribeToFlashcards({required String deckId}) async {
    _flashcardsProvider.subscribeToDeckFlashcards(
      deckId: deckId,
      onData: (realtimeMessage) async {
        final flashcardDoc = realtimeMessage.toFlashcardDocument;
        _controller.add(flashcardDoc.toFlashcard);
      },
    );

    _recallsProvider.subscribe(
      userId: (await currentUser)!.id,
      onData: (realtimeMessage) async {
        final recallDoc = realtimeMessage.toRecallDocument;
        final flashcardDoc = await _flashcardsProvider.getFlashcard(
          recallDoc.data['flashcard'] as String,
        );

        final flashcard = flashcardDoc.toFlashcard.copyWith(
          recall: recallDoc.toRecall,
        );

        _controller.add(flashcard);
      },
    );
  }

  Future<void> createFlashcard({
    required Flashcard flashcard,
    String? teamId,
  }) async {
    teamId == null
        ? await _createPersonalFlashcard(flashcard)
        : await _createTeamFlashcard(flashcard, teamId);
  }

  Future<void> _createPersonalFlashcard(Flashcard flashcard) async {
    final flashcardDoc = await _flashcardsProvider.createFlashcard(
      front: flashcard.front,
      back: flashcard.back,
      deckId: flashcard.deckId,
      permissions: ['user:${(await currentUser)?.id}'],
    );

    await _recallsProvider.create(
      flashcardId: flashcardDoc.$id,
      userId: (await currentUser)!.id,
    );
  }

  Future<void> _createTeamFlashcard(
    Flashcard flashcard,
    String teamId,
  ) async {
    final flashcardDoc = await _flashcardsProvider.createFlashcard(
      front: flashcard.front,
      back: flashcard.back,
      deckId: flashcard.deckId,
      permissions: ['team:$teamId'],
    );

    final memberships = await _teamsProvider.getMemberships(teamId);
    for (final membership in memberships) {
      await _recallsProvider.create(
        flashcardId: flashcardDoc.$id,
        userId: membership.userId,
        permissions: ['team:$teamId'],
      );
    }
  }

  Future<List<Flashcard>> getFlashcards(Deck deck) async {
    final flashcards = <Flashcard>[];
    final docs = await _flashcardsProvider.getFlashcards(deck.id);

    for (final doc in docs) {
      final flashcard = await getFlashcard(doc.$id);
      flashcards.add(flashcard);
    }

    return flashcards;
  }

  Future<List<Flashcard>> getTodayFlashcards() async {
    final flashcards = <Flashcard>[];
    final recallDocs = await _recallsProvider.getTodayRecalls(
      (await currentUser)!.id,
    );

    final recalls = recallDocs.map((e) => e.toRecall).toList();
    for (final recall in recalls) {
      final flashcardDoc = await _flashcardsProvider.getFlashcard(
        recall.flashcardId,
      );
      final flashcard = flashcardDoc.toFlashcard.copyWith(recall: recall);
      flashcards.add(flashcard);
    }

    return flashcards;
  }

  Future<void> updateFlashcardRecall({
    required Flashcard flashcard,
    required int weight,
  }) async {
    final Flashcard flashcardComplete;
    if (flashcard.recall == null) {
      final recall = await _recallsProvider.getRecall(
        flashcard.id!,
        (await currentUser)!.id,
      );

      flashcardComplete = flashcard.copyWith(
        recall: recall.toRecall,
      );
    } else {
      flashcardComplete = flashcard.copyWith();
    }

    await _recallsProvider.update(
      flashcardComplete.recall!.id,
      flashcardComplete.recall!.lastDifferenceHours,
      weight,
    );
  }

  Future<Flashcard> getFlashcard(String flashcardId) async {
    final flashcardDoc = await _flashcardsProvider.getFlashcard(flashcardId);
    final flashcard = flashcardDoc.toFlashcard;

    final recallDoc = await _recallsProvider.getRecall(
      flashcardId,
      (await currentUser)!.id,
    );

    return flashcard.copyWith(recall: recallDoc.toRecall);
  }

  void dispose() {
    _controller.close();
    _flashcardsProvider.dispose();
    _recallsProvider.dispose();
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
      userId: data['user'] as String,
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

  appw_models.Document get toRecallDocument {
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
        'flashcard': payload['flashcard'],
        'user': payload['user'],
        'next_repetition': payload['next_repetition'],
        'last_hours_interval': payload['last_hours_interval'],
      },
    );
  }
}
