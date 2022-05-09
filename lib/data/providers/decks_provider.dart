import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class DecksProvider {
  DecksProvider({
    required Client client,
  })  : _realtime = Realtime(client),
        database = Database(client) {
    _subscription = _realtime.subscribe([_channel]);
  }

  final String _channel = 'collections.6274b3a4b5a85ff61130.documents';
  final String collectionId = '6274b3a4b5a85ff61130';
  final Realtime _realtime;
  late RealtimeSubscription _subscription;
  final Database database;

  void subscribeToTeamDecks({
    required String teamId,
    required void Function(RealtimeMessage) onData,
  }) {
    _subscription.stream.listen((event) {
      final deckDoc = event.payload as Document;
      final belongsToTeam = deckDoc.$read.contains('team:$teamId');
      if (belongsToTeam) {
        onData(event);
      }
    });
  }

  Future<void> createPersonalDeck(String title, String userId) async {
    await database.createDocument(
      collectionId: collectionId,
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
    await database.createDocument(
      collectionId: collectionId,
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
}
