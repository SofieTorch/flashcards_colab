import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:flashcards_colab/data/providers/decks_provider.dart';
import 'package:flashcards_colab/data/providers/flashcards_provider.dart';
import 'package:flashcards_colab/data/providers/recalls_provider.dart';
import 'package:flashcards_colab/data/providers/teams_database_provider.dart';
import 'package:flashcards_colab/data/providers/teams_provider.dart';
import 'package:flashcards_colab/models/models.dart';

class TeamsRepository {
  TeamsRepository({required this.client})
      : _databaseProvider = TeamsDatabaseProvider(Database(client)),
        _teamsProvider = TeamsProvider(client: client),
        _recallsProvider = RecallsProvider(client),
        _decksProvider = DecksProvider(client: client),
        _flashcardsProvider = FlashcardsProvider(client);

  final Client client;
  final TeamsDatabaseProvider _databaseProvider;
  final TeamsProvider _teamsProvider;
  final RecallsProvider _recallsProvider;
  final DecksProvider _decksProvider;
  final FlashcardsProvider _flashcardsProvider;

  Future<void> create(Team team) async {
    final teamAccount = await _teamsProvider.create(team.name);
    await _databaseProvider.create(
      id: teamAccount.$id,
      name: team.name,
      description: team.description,
    );
  }

  Future<List<Team>> getTeams() async {
    final teamAccounts = await _teamsProvider.getTeams();

    final teams = <Team>[];
    for (final account in teamAccounts) {
      final team = await getTeam(account.$id);
      teams.add(team);
    }

    return teams;
  }

  Future<Team> getTeam(String teamId) async {
    final teamDoc = await _databaseProvider.getTeam(teamId);
    final teamAccount = await _teamsProvider.getTeam(teamId);
    return teamDoc.toTeam.copyWith(members: teamAccount.total);
  }

  Future<void> addMember(String teamId, String email) async {
    final membership = await _teamsProvider.createMembership(
      teamId: teamId,
      email: email,
    );
    final deckDocs = await _decksProvider.getAllTeamDecks(teamId);
    for (final deckDoc in deckDocs) {
      final flashcards = await _flashcardsProvider.getFlashcards(deckDoc.$id);
      for (final flashcardDoc in flashcards) {
        await _recallsProvider.create(
          flashcardId: flashcardDoc.$id,
          userId: membership.userId,
          permissions: ['team:$teamId'],
        );
      }
    }
  }

  Future<void> joinTeam(Membership membership) async {
    await _teamsProvider.updateMembershipStatus(
      teamId: membership.teamId,
      membershipId: membership.membershipId,
      userId: membership.userId,
      secret: membership.secret,
    );
  }
}

extension on appwrite_models.Document {
  Team get toTeam {
    return Team(
      id: $id,
      name: data['name'] as String,
      description: data['description'] as String,
    );
  }
}
