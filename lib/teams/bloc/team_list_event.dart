part of 'team_list_bloc.dart';

abstract class TeamListEvent extends Equatable {
  const TeamListEvent();

  @override
  List<Object> get props => [];
}

class TeamListRequested extends TeamListEvent {
  const TeamListRequested();
}

class NewTeamNameChanged extends TeamListEvent {
  const NewTeamNameChanged(this.name);
  final String name;

  @override
  List<Object> get props => [name];
}

class NewTeamDescriptionChanged extends TeamListEvent {
  const NewTeamDescriptionChanged(this.description);
  final String description;

  @override
  List<Object> get props => [description];
}

class NewTeamCreated extends TeamListEvent {
  const NewTeamCreated();
}
