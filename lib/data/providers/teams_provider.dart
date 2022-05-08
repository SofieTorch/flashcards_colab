import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class TeamsProvider {
  TeamsProvider({required Client client}) : teams = Teams(client);

  final Teams teams;

  Future<Team> create(String name) {
    return teams.create(teamId: 'unique()', name: name);
  }

  Future<List<Team>> getTeams() async {
    final teamList = await teams.list();
    return teamList.teams;
  }

  Future<void> createMembership({
    required String teamId,
    required String email,
  }) async {
    await teams.createMembership(
      teamId: teamId,
      email: email,
      roles: <String>['member'],
      url: 'http://206.189.103.151/create-membership',
    );
  }

  Future<Team> update(String teamId, String name) {
    return teams.update(teamId: teamId, name: name);
  }

  Future<void> delete(String teamId) async {
    await teams.delete(teamId: teamId);
  }
}
