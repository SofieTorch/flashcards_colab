part of 'join_team_bloc.dart';

enum JoinTeamStatus { initial, inProgress, success, failure }
enum RetrieveTeamStatus { initial, inProgress, success, failure }

class JoinTeamState extends Equatable {
  const JoinTeamState({
    required this.membership,
    this.team = const Team(),
    this.status = JoinTeamStatus.initial,
    this.teamStatus = RetrieveTeamStatus.initial,
  });

  final Membership membership;
  final Team team;
  final JoinTeamStatus status;
  final RetrieveTeamStatus teamStatus;

  JoinTeamState copyWith({
    Membership? membership,
    Team? team,
    JoinTeamStatus? status,
    RetrieveTeamStatus? teamStatus,
  }) {
    return JoinTeamState(
      membership: membership ?? this.membership,
      team: team ?? this.team,
      status: status ?? this.status,
      teamStatus: teamStatus ?? this.teamStatus,
    );
  }

  @override
  List<Object> get props => [membership, team, status, teamStatus];
}
