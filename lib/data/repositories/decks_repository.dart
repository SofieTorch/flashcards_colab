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
  final User currentUser;

  Future<void> createPersonalDeck(String title) async {
    await database.createDocument(
      collectionId: '6259f91677c38039713e',
      documentId: 'unique()',
      write: <String>['user:${currentUser.id}'],
      read: <String>['user:${currentUser.id}'],
      data: <String, dynamic>{
        'name': title,
        'created_at': DateTime.now(),
      },
    );
  }

  Future<List<Deck>> getPersonalDecks({int limit = 10, int offset = 0}) async {
    final deckDocs = await database.listDocuments(
      collectionId: '6259f91677c38039713e',
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
      id: $id,
    );
  }
}
