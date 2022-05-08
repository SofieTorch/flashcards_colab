part of 'join_team_bloc.dart';

abstract class JoinTeamEvent extends Equatable {
  const JoinTeamEvent();

  @override
  List<Object> get props => [];
}

class TeamRequested extends JoinTeamEvent {
  const TeamRequested();
}

class TeamInvitationAccepted extends JoinTeamEvent {
  const TeamInvitationAccepted();
}
