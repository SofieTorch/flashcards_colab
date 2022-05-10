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

  Future<List<Membership>> getMemberships(String teamId) async {
    final membershipsList = await teams.getMemberships(teamId: teamId);
    return membershipsList.memberships;
  }

  Future<void> createMembership({
    required String teamId,
    required String email,
  }) async {
    await teams.createMembership(
      teamId: teamId,
      email: email,
      roles: <String>['owner'],
      url: 'http://206.189.103.151/join',
    );
  }

  Future<void> updateMembershipStatus({
    required String teamId,
    required String membershipId,
    required String userId,
    required String secret,
  }) async {
    await teams.updateMembershipStatus(
      teamId: teamId,
      membershipId: membershipId,
      userId: userId,
      secret: secret,
    );
  }

  Future<Team> update(String teamId, String name) {
    return teams.update(teamId: teamId, name: name);
  }

  Future<void> delete(String teamId) async {
    await teams.delete(teamId: teamId);
  }
}
