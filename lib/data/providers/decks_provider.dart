import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class DecksProvider {
  DecksProvider({
    required Client client,
  })  : _realtime = Realtime(client),
        _database = Database(client) {
    _subscription = _realtime.subscribe([_channel]);
  }

  final String _channel = 'collections.6274b3a4b5a85ff61130.documents';
  final String _collectionId = '6274b3a4b5a85ff61130';
  final Realtime _realtime;
  final Database _database;
  late RealtimeSubscription _subscription;

  void subscribeToTeamDecks({
    required String teamId,
    required void Function(RealtimeMessage) onData,
  }) {
    _subscription.stream.listen((event) {
      // ignore: use_raw_strings
      final raw = event.payload['\$read'] as List<dynamic>;
      final readPermissions = raw.map((dynamic e) => e.toString()).toList();
      final belongsToTeam = readPermissions.contains('team:$teamId');
      if (belongsToTeam) {
        onData(event);
      }
    });
  }

  Future<void> createPersonalDeck(String title, String userId) async {
    await _database.createDocument(
      collectionId: _collectionId,
      documentId: 'unique()',
      write: <String>['user:$userId'],
      read: <String>['user:$userId'],
      data: <String, dynamic>{
        'name': title,
        'owner_id': userId,
      },
    );
  }

  Future<void> createTeamDeck(String title, String teamId) async {
    await _database.createDocument(
      collectionId: _collectionId,
      documentId: 'unique()',
      write: <String>['team:$teamId'],
      read: <String>['team:$teamId'],
      data: <String, dynamic>{
        'name': title,
        'owner_id': teamId,
        'type': 'team',
      },
    );
  }

  Future<List<Document>> getPersonalDecks({
    int limit = 10,
    int offset = 0,
  }) async {
    final deckDocs = await _database.listDocuments(
      collectionId: _collectionId,
      limit: limit,
      offset: offset,
      queries: <dynamic>[
        Query.equal('type', 'personal'),
      ],
    );

    return deckDocs.documents;
  }

  Future<List<Document>> getTeamDecks({
    required String teamId,
    int limit = 10,
    int offset = 0,
  }) async {
    final deckDocs = await _database.listDocuments(
      collectionId: _collectionId,
      limit: limit,
      offset: offset,
      queries: <dynamic>[
        Query.equal('type', 'team'),
        Query.equal('owner_id', teamId),
      ],
    );

    return deckDocs.documents;
  }

  Future<List<Document>> getAllTeamDecks(String teamId) async {
    final deckDocs = await _database.listDocuments(
      collectionId: _collectionId,
      queries: <dynamic>[
        Query.equal('type', 'team'),
        Query.equal('owner_id', teamId),
      ],
    );
    return deckDocs.documents;
  }

  void dispose() {
    _subscription.close();
  }
}
