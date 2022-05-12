import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards_colab/data/repositories/teams_repository.dart';
import 'package:flashcards_colab/models/team.dart';
import 'package:flashcards_colab/sign_in/models/email.dart';
import 'package:formz/formz.dart';

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
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        newMemberEmail: email,
        status: Formz.validate([email]),
      ),
    );
  }

  Future<void> _onNewMemberInvited(
    NewMemberInvited event,
    Emitter<TeamState> emit,
  ) async {
    emit(state.copyWith(newMemberStatus: NewMemberStatus.inProgress));
    await _teamsRepository.addMember(state.team.id, state.newMemberEmail.value);
    emit(state.copyWith(newMemberStatus: NewMemberStatus.success));
  }
}
