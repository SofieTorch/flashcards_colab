import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'team_list_event.dart';
part 'team_list_state.dart';

class TeamListBloc extends Bloc<TeamListEvent, TeamListState> {
  TeamListBloc() : super(TeamListInitial()) {
    on<TeamListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
