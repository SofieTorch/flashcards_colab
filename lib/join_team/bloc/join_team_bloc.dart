import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards_colab/data/repositories/teams_repository.dart';
import 'package:flashcards_colab/models/models.dart';

part 'join_team_event.dart';
part 'join_team_state.dart';

class JoinTeamBloc extends Bloc<JoinTeamEvent, JoinTeamState> {
  JoinTeamBloc({
    required Membership membership,
    required TeamsRepository teamsRepository,
  })  : _teamsRepository = teamsRepository,
        super(JoinTeamState(membership: membership)) {
    on<TeamRequested>(_onTeamRequested);
    on<TeamInvitationAccepted>(_onTeamInvitationAccepted);
  }

  final TeamsRepository _teamsRepository;

  Future<void> _onTeamRequested(
    TeamRequested event,
    Emitter<JoinTeamState> emit,
  ) async {
    try {
      emit(state.copyWith(teamStatus: RetrieveTeamStatus.inProgress));
      final team = await _teamsRepository.getTeam(state.membership.teamId);
      emit(state.copyWith(team: team, teamStatus: RetrieveTeamStatus.success));
    } catch (e) {
      emit(state.copyWith(teamStatus: RetrieveTeamStatus.failure));
    }
  }

  Future<void> _onTeamInvitationAccepted(
    TeamInvitationAccepted event,
    Emitter<JoinTeamState> emit,
  ) async {
    // try {
    emit(state.copyWith(status: JoinTeamStatus.inProgress));
    await _teamsRepository.joinTeam(state.membership);
    emit(state.copyWith(status: JoinTeamStatus.success));
    // } catch (e) {
    //   emit(state.copyWith(status: JoinTeamStatus.failure));
    // }
  }
}
