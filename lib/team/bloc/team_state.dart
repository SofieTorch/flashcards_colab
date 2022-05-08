part of 'team_bloc.dart';

enum NewMemberStatus { initial, inProgress, success, failure }

class TeamState extends Equatable {
  const TeamState({
    required this.team,
    this.newMemberEmail = '',
    this.newMemberStatus = NewMemberStatus.initial,
  });

  final Team team;
  final String newMemberEmail;
  final NewMemberStatus newMemberStatus;

  TeamState copyWith({
    Team? team,
    String? newMemberEmail,
    NewMemberStatus? newMemberStatus,
  }) {
    return TeamState(
      team: team ?? this.team,
      newMemberEmail: newMemberEmail ?? this.newMemberEmail,
      newMemberStatus: newMemberStatus ?? this.newMemberStatus,
    );
  }

  @override
  List<Object> get props => [newMemberEmail, newMemberStatus];
}
