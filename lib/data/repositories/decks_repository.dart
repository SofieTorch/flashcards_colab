// ignore_for_file: use_raw_strings

import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appw_models;
import 'package:flashcards_colab/data/providers/decks_provider.dart';
import 'package:flashcards_colab/models/models.dart';

class DecksRepository {
  DecksRepository({
    required Client client,
    required this.currentUser,
  }) : _provider = DecksProvider(client: client);

  final FutureOr<User> currentUser;
  final DecksProvider _provider;

  Future<void> createDeck({
    required String title,
    String? teamId,
  }) async {
    teamId == null
        ? await _provider.createPersonalDeck(title, (await currentUser).id)
        : await _provider.createTeamDeck(title, teamId);
  }

  Future<List<Deck>> getDecks({
    String? teamId,
    int limit = 10,
    int offset = 0,
  }) async {
    final List<appw_models.Document> deckDocs;
    if (teamId == null) {
      deckDocs = await _provider.getPersonalDecks(
        limit: limit,
        offset: offset,
      );
    } else {
      deckDocs = await _provider.getTeamDecks(
        teamId: teamId,
        limit: limit,
        offset: offset,
      );
    }

    final decks = deckDocs.map((doc) => doc.toDeck).toList();
    return decks;
  }

  void subscribeToTeamDecks({
    required String teamId,
    required void Function(Deck) onData,
  }) {
    _provider.subscribeToTeamDecks(
      teamId: teamId,
      onData: (realtimeMessage) {
        final deckDoc = realtimeMessage.toDeckDocument;
        onData(deckDoc.toDeck);
      },
    );
  }
}

extension on appw_models.Document {
  Deck get toDeck {
    return Deck(
      title: data['name'] as String,
      cardsCount: data['cards_count'] as int,
      id: $id,
    );
  }
}

extension on RealtimeMessage {
  appw_models.Document get toDeckDocument {
    final readRaw = payload['\$read'] as List<dynamic>;
    final readPermissions = readRaw.map((dynamic e) => e.toString()).toList();
    final writeRaw = payload['\$read'] as List<dynamic>;
    final writePermissions = writeRaw.map((dynamic e) => e.toString()).toList();

    return appw_models.Document(
      $id: payload['\$id'] as String,
      $collection: payload['\$collection'] as String,
      $read: readPermissions,
      $write: writePermissions,
      data: <String, dynamic>{
        'name': payload['name'],
        'owner_id': payload['owner_id'],
        'type': payload['type'],
      },
    );
  }
}
