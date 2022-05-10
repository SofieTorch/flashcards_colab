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

  Future<void> update(String id, int lastDifferenceHours, int weight) async {
    final nextDifferenceHours =
        _getNextDifferenceHours(lastDifferenceHours, weight);

    await _database.updateDocument(
      collectionId: _collectionId,
      documentId: id,
      data: <String, dynamic>{
        'last_hours_interval': nextDifferenceHours,
        'next_repetition': DateTime.now().add(
          Duration(hours: nextDifferenceHours),
        ),
      },
    );
  }

  int _getNextDifferenceHours(int last, int weight) {
    if (weight == 0) return minHoursForNextStudy;

    final nextAccumulation = (last * weight) / 2 as int;
    return last == minHoursForNextStudy
        ? minHoursForNextStudy * pow(2, weight) as int
        : nextAccumulation;
  }

  void dispose() {
    _subscription.close();
  }
}
