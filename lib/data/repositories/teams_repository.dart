import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:flashcards_colab/data/providers/teams_database_provider.dart';
import 'package:flashcards_colab/data/providers/teams_provider.dart';
import 'package:flashcards_colab/models/models.dart';

class TeamsRepository {
  TeamsRepository(this.client)
      : _databaseProvider = TeamsDatabaseProvider(Database(client)),
        _teamsProvider = TeamsProvider(client: client);

  final Client client;
  final TeamsDatabaseProvider _databaseProvider;
  final TeamsProvider _teamsProvider;

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
      final teamDoc = await _databaseProvider.getTeam(account.$id);
      teams.add(teamDoc.toTeam);
    }

    return teams;
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
