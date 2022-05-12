import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class RoomsProvider {
  RoomsProvider(Client client)
      : _database = Database(client),
        _realtime = Realtime(client),
        _functions = Functions(client) {
    _deckSubscription = _realtime.subscribe([_channel]);
  }

  final String _collectionId = '627bcb768984b15ff9a0';
  final String _channel = 'collections.627bcb768984b15ff9a0.documents';
  final Database _database;
  final Realtime _realtime;
  final Functions _functions;
  late RealtimeSubscription _deckSubscription;
  RealtimeSubscription? _roomSubscription;

  void subscribeToDeckRoom({
    required String deckId,
    required void Function(RealtimeMessage) onData,
  }) {
    _deckSubscription.stream.listen((event) {
      final eventDeckId = event.payload['deck'] as String;
      if (eventDeckId == deckId) {
        onData(event);
      }
    });
  }

  void subscribeToRoom({
    required String roomId,
    required void Function(RealtimeMessage) onData,
  }) {
    _roomSubscription = _realtime.subscribe(['$_channel.$roomId']);
    _roomSubscription?.stream.listen(onData);
  }

  Future<Document> create({
    required String teamId,
    required String deckId,
    required String currentFlashcardId,
  }) async {
    return _database.createDocument(
      collectionId: _collectionId,
      documentId: 'unique()',
      read: <String>['team:$teamId'],
      write: <String>['team:$teamId'],
      data: <String, dynamic>{
        'deck': deckId,
        'current_flashcard': currentFlashcardId,
      },
    );
  }

  Future<void> delete(String roomId) async {
    await _database.deleteDocument(
      collectionId: _collectionId,
      documentId: roomId,
    );
  }

  Future<Document> getRoomByDeck(String deckId) async {
    final docs = await _database.listDocuments(
      collectionId: _collectionId,
      queries: <dynamic>[Query.equal('deck', deckId)],
    );

    return docs.documents[0];
  }

  Future<void> updateAttendeesCount(
    String roomId,
    int currentAttendees,
  ) async {
    await _database.updateDocument(
      collectionId: _collectionId,
      documentId: roomId,
      data: <String, dynamic>{
        'attendees_count': currentAttendees + 1,
      },
    );
  }

  Future<void> updateAnswersCount(
    String roomId,
    int currentAnswersCount,
  ) async {
    await _database.updateDocument(
      collectionId: _collectionId,
      documentId: roomId,
      data: <String, dynamic>{
        'answers_count': currentAnswersCount + 1,
      },
    );
  }

  Future<void> updateFlashcard({
    required String roomId,
    required String newFlashcardId,
  }) async {
    final data = {
      'answers_count': 0,
      'current_flashcard': newFlashcardId,
    };

    await _database.updateDocument(
      collectionId: _collectionId,
      documentId: roomId,
      data: data,
    );
  }

  void dispose() {
    _deckSubscription.close();
    _roomSubscription?.close();
  }
}
