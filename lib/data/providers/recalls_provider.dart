import 'dart:math';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class RecallsProvider {
  RecallsProvider(Client client) : database = Database(client);

  final Database database;
  final String collectionId = '6274b3c183b8d2814f25';
  final int minHoursForNextStudy = 12;

  Future<Document> getRecall(String flashcardId) async {
    final docs = await database.listDocuments(
      collectionId: collectionId,
      queries: <dynamic>[
        Query.equal('flashcard', flashcardId),
      ],
    );

    return docs.documents[0];
  }

  Future<void> create(String flashcardId, String userId) async {
    await database.createDocument(
      collectionId: collectionId,
      documentId: 'unique()',
      data: <String, dynamic>{
        'flashcard': flashcardId,
        'user': userId,
        'last_hours_interval': minHoursForNextStudy,
        'next_repetition': DateTime.now()
            .add(Duration(hours: minHoursForNextStudy))
            .millisecondsSinceEpoch,
      },
      write: <String>['user:$userId'],
      read: <String>['user:$userId'],
    );
  }

  Future<void> update(String id, int lastDifferenceHours, int weight) async {
    final nextDifferenceHours =
        _getNextDifferenceHours(lastDifferenceHours, weight);

    await database.updateDocument(
      collectionId: collectionId,
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
}
