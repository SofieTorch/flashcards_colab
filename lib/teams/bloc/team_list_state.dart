part of 'team_list_bloc.dart';

enum TeamListStatus { initial, loading, success, failure }
enum NewTeamStatus { initial, inProgress, success, failure }

class TeamListState extends Equatable {
  const TeamListState({
    this.teams = const [],
    this.status = TeamListStatus.initial,
    this.newTeam = const Team(),
    this.newTeamStatus = NewTeamStatus.initial,
  });

  final List<Team> teams;
  final TeamListStatus status;
  final Team newTeam;
  final NewTeamStatus newTeamStatus;

  TeamListState copyWith({
    List<Team>? teams,
    TeamListStatus? status,
    Team? newTeam,
    NewTeamStatus? newTeamStatus,
  }) {
    return TeamListState(
      teams: teams ?? this.teams,
      status: status ?? this.status,
      newTeam: newTeam ?? this.newTeam,
      newTeamStatus: newTeamStatus ?? this.newTeamStatus,
    );
  }

  @override
  List<Object> get props => [teams, status, newTeam, newTeamStatus];
}
