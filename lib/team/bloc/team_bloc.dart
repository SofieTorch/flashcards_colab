import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards_colab/data/repositories/teams_repository.dart';
import 'package:flashcards_colab/models/team.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  TeamBloc({required Team team, required TeamsRepository teamsRepository})
      : _teamsRepository = teamsRepository,
        super(TeamState(team: team)) {
    on<NewMemberEmailChanged>(_onNewMemberEmailChanged);
    on<NewMemberInvited>(_onNewMemberInvited);
  }

  final TeamsRepository _teamsRepository;

  void _onNewMemberEmailChanged(
    NewMemberEmailChanged event,
    Emitter<TeamState> emit,
  ) {
    emit(state.copyWith(newMemberEmail: event.email));
  }

  Future<void> _onNewMemberInvited(
    NewMemberInvited event,
    Emitter<TeamState> emit,
  ) async {
    emit(state.copyWith(newMemberStatus: NewMemberStatus.inProgress));
    await _teamsRepository.addMember(state.team.id, state.newMemberEmail);
    emit(state.copyWith(newMemberStatus: NewMemberStatus.success));
  }
}
