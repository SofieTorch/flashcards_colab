import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:flashcards_colab/data/providers/decks_provider.dart';
import 'package:flashcards_colab/models/models.dart';

class DecksRepository {
  DecksRepository({
    required Client awClient,
    required this.currentUser,
  })  : database = Database(awClient),
        _provider = DecksProvider(client: awClient);

  final Database database;
  final FutureOr<User> currentUser;
  final String collectionId = '6274b3a4b5a85ff61130';
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
    return teamId == null
        ? await getPersonalDecks(limit: limit, offset: offset)
        : await getTeamDecks(teamId: teamId, limit: limit, offset: offset);
  }

  Future<List<Deck>> getPersonalDecks({int limit = 10, int offset = 0}) async {
    final deckDocs = await database.listDocuments(
      collectionId: collectionId,
      limit: limit,
      offset: offset,
      queries: <dynamic>[
        Query.equal('type', 'personal'),
      ],
    );

    final decks = deckDocs.documents.map((doc) => doc.toDeck).toList();
    return decks;
  }

  Future<List<Deck>> getTeamDecks({
    required String teamId,
    int limit = 10,
    int offset = 0,
  }) async {
    final deckDocs = await database.listDocuments(
      collectionId: collectionId,
      limit: limit,
      offset: offset,
      queries: <dynamic>[
        Query.equal('type', 'team'),
        Query.equal('owner_id', teamId),
      ],
    );

    final decks = deckDocs.documents.map((doc) => doc.toDeck).toList();
    return decks;
  }

  void subscribeFromTeam({
    required String teamId,
    required void Function(RealtimeMessage) onData,
  }) =>
      _provider.subscribeToTeamDecks(
        teamId: teamId,
        onData: onData,
      );
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
