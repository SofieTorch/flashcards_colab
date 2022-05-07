part of 'team_list_bloc.dart';

abstract class TeamListState extends Equatable {
  const TeamListState();
  
  @override
  List<Object> get props => [];
}

class TeamListInitial extends TeamListState {}
