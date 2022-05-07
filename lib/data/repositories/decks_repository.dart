import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:flashcards_colab/models/models.dart';

class DecksRepository {
  DecksRepository({
    required this.awClient,
    required this.currentUser,
  }) : database = Database(awClient);

  final Client awClient;
  final Database database;
  final FutureOr<User> currentUser;
  final String collectionId = '6274b3a4b5a85ff61130';

  Future<void> createPersonalDeck(String title) async {
    await database.createDocument(
      collectionId: collectionId,
      documentId: 'unique()',
      write: <String>['user:${(await currentUser).id}'],
      read: <String>['user:${(await currentUser).id}'],
      data: <String, dynamic>{
        'name': title,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  Future<List<Deck>> getPersonalDecks({int limit = 10, int offset = 0}) async {
    final deckDocs = await database.listDocuments(
      collectionId: collectionId,
      limit: limit,
      offset: offset,
    );

    final decks = deckDocs.documents.map((doc) => doc.toDeck).toList();
    return decks;
  }
}

extension on appwrite_models.Document {
  Deck get toDeck {
    return Deck(
      title: data['name'] as String,
      cardsCount: data['cards_count'] as int,
      id: $id,
    );
  }
}
