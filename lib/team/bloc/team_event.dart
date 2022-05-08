part of 'team_bloc.dart';

abstract class TeamEvent extends Equatable {
  const TeamEvent();

  @override
  List<Object> get props => [];
}

class NewMemberEmailChanged extends TeamEvent {
  const NewMemberEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class NewMemberInvited extends TeamEvent {
  const NewMemberInvited();
}
