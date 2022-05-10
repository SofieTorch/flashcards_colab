import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class FlashcardsProvider {
  FlashcardsProvider(Client client)
      : _realtime = Realtime(client),
        _database = Database(client) {
    _subscription = _realtime.subscribe([_channel]);
  }

  final String _channel = 'collections.6274b3b2ccb704998e68.documents';
  final String _collectionId = '6274b3b2ccb704998e68';
  final Database _database;
  final Realtime _realtime;
  late RealtimeSubscription _subscription;

  void subscribeToDeckFlashcards({
    required String deckId,
    required void Function(RealtimeMessage) onData,
  }) {
    _subscription.stream.listen((event) {
      final docDeckId = event.payload['deck'] as String;
      if (docDeckId == deckId) {
        onData(event);
      }
    });
  }

  Future<Document> createFlashcard({
    required String front,
    required String back,
    required String deckId,
    required List<String> permissions,
  }) {
    return _database.createDocument(
      collectionId: _collectionId,
      documentId: 'unique()',
      data: <String, dynamic>{
        'front_content': front,
        'back_content': back,
        'deck': deckId,
      },
      write: permissions,
      read: permissions,
    );
  }

  Future<List<Document>> getFlashcards(String deckId) async {
    final docs = await _database.listDocuments(
      collectionId: _collectionId,
      queries: <dynamic>[
        Query.equal('deck', deckId),
      ],
    );

    return docs.documents;
  }

  Future<Document> getFlashcard(String flashcardId) {
    return _database.getDocument(
      collectionId: _collectionId,
      documentId: flashcardId,
    );
  }

  void dispose() {
    _subscription.close();
  }
}
