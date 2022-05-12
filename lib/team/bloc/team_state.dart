part of 'team_bloc.dart';

enum NewMemberStatus { initial, inProgress, success, failure }

class TeamState extends Equatable {
  const TeamState({
    required this.team,
    this.newMemberEmail = const Email.pure(),
    this.newMemberStatus = NewMemberStatus.initial,
    this.status = FormzStatus.pure,
  });

  final Team team;
  // final String newMemberEmail;
  final NewMemberStatus newMemberStatus;
  final Email newMemberEmail;
  final FormzStatus status;

  TeamState copyWith({
    Team? team,
    Email? newMemberEmail,
    NewMemberStatus? newMemberStatus,
    FormzStatus? status,
  }) {
    return TeamState(
      team: team ?? this.team,
      newMemberEmail: newMemberEmail ?? this.newMemberEmail,
      newMemberStatus: newMemberStatus ?? this.newMemberStatus,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [team, newMemberEmail, newMemberStatus, status];
}
