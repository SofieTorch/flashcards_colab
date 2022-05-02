import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class FlashcardsProvider {
  FlashcardsProvider(Client client) : database = Database(client);

  final Database database;
  final String collectionId = '6259bc53deb082f0bb01';

  Future<Document> createFlashcard({
    required String front,
    required String back,
    required String deckId,
    required List<String> permissions,
  }) {
    return database.createDocument(
      collectionId: collectionId,
      documentId: 'unique()',
      data: <String, dynamic>{
        'front_content': front,
        'back_content': back,
        'deck_id': deckId,
      },
      write: permissions,
      read: permissions,
    );
  }

  Future<List<Document>> getFlashcards(String deckId) async {
    final docs = await database.listDocuments(
      collectionId: collectionId,
      queries: <dynamic>[
        Query.equal('deck_id', deckId),
      ],
    );

    return docs.documents;
  }
}
