import 'dart:math';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class RecallsProvider {
  RecallsProvider(Client client)
      : _database = Database(client),
        _realtime = Realtime(client) {
    _subscription = _realtime.subscribe([_channel]);
  }

  final String _channel = 'collections.6274b3c183b8d2814f25.documents';
  final String _collectionId = '6274b3c183b8d2814f25';
  final int minHoursForNextStudy = 12;
  final Database _database;
  final Realtime _realtime;
  late RealtimeSubscription _subscription;

  void subscribe({
    required String userId,
    required void Function(RealtimeMessage) onData,
  }) {
    _subscription.stream.listen((event) {
      final docUserId = event.payload['user'] as String;
      if (docUserId == userId) {
        onData(event);
      }
    });
  }

  Future<Document> getRecall(String flashcardId, String userId) async {
    final docs = await _database.listDocuments(
      collectionId: _collectionId,
      queries: <dynamic>[
        Query.equal('flashcard', flashcardId),
        Query.equal('user', userId),
      ],
    );

    return docs.documents[0];
  }

  Future<List<Document>> getTodayRecalls(String userId) async {
    final docs = <Document>[];
    final today = DateTime.now();
    final fetchedDocs = await _database.listDocuments(
      collectionId: _collectionId,
      queries: <dynamic>[
        Query.equal('user', userId),
      ],
    );

    for (final doc in fetchedDocs.documents) {
      final nextRepetitionMiliseconds = doc.data['next_repetition'] as int;
      final nextRepetition =
          DateTime.fromMillisecondsSinceEpoch(nextRepetitionMiliseconds);
      if (nextRepetition.isBefore(today)) {
        docs.add(doc);
      }
    }

    return docs;
  }

  Future<void> create({
    required String flashcardId,
    required String userId,
    List<String>? permissions,
  }) async {
    await _database.createDocument(
      collectionId: _collectionId,
      documentId: 'unique()',
      data: <String, dynamic>{
        'flashcard': flashcardId,
        'user': userId,
        'last_hours_interval': minHoursForNextStudy,
        'next_repetition': DateTime.now()
            .add(Duration(hours: minHoursForNextStudy))
            .millisecondsSinceEpoch,
      },
      write: permissions ?? <String>['user:$userId'],
      read: permissions ?? <String>['user:$userId'],
    );
  }

  Future<void> update(String id, int lastHoursInterval, int weight) async {
    final nextHoursInterval =
        _getNextDifferenceHours(lastHoursInterval, weight);

    await _database.updateDocument(
      collectionId: _collectionId,
      documentId: id,
      data: <String, dynamic>{
        'last_hours_interval': nextHoursInterval,
        'next_repetition': DateTime.now()
            .add(Duration(hours: nextHoursInterval))
            .millisecondsSinceEpoch,
      },
    );
  }

  int _getNextDifferenceHours(int last, int weight) {
    if (weight == 0) return minHoursForNextStudy;

    final nextAccumulation = (last * weight / 2).round();
    return last == minHoursForNextStudy
        ? minHoursForNextStudy * pow(2, weight).round()
        : nextAccumulation;
  }

  void dispose() {
    _subscription.close();
  }
}
