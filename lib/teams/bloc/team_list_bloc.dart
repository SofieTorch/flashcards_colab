import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards_colab/data/repositories/teams_repository.dart';
import 'package:flashcards_colab/models/models.dart';

part 'team_list_event.dart';
part 'team_list_state.dart';

class TeamListBloc extends Bloc<TeamListEvent, TeamListState> {
  TeamListBloc({required TeamsRepository teamsRepository})
      : _teamsRepository = teamsRepository,
        super(const TeamListState()) {
    on<TeamListRequested>(_onTeamListRequested);
    on<NewTeamNameChanged>(_onNewTeamNameChanged);
    on<NewTeamDescriptionChanged>(_onNewTeamDescriptionChanged);
    on<NewTeamCreated>(_onNewTeamCreated);
  }

  final TeamsRepository _teamsRepository;

  Future<void> _onTeamListRequested(
    TeamListRequested event,
    Emitter<TeamListState> emit,
  ) async {
    try {
      emit(state.copyWith(status: TeamListStatus.loading));
      final teams = await _teamsRepository.getTeams();
      emit(state.copyWith(teams: teams, status: TeamListStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TeamListStatus.failure));
    }
  }

  Future<void> _onNewTeamNameChanged(
    NewTeamNameChanged event,
    Emitter<TeamListState> emit,
  ) async {
    emit(
      state.copyWith(
        newTeam: state.newTeam.copyWith(
          name: event.name,
        ),
      ),
    );
  }

  Future<void> _onNewTeamDescriptionChanged(
    NewTeamDescriptionChanged event,
    Emitter<TeamListState> emit,
  ) async {
    emit(
      state.copyWith(
        newTeam: state.newTeam.copyWith(
          description: event.description,
        ),
      ),
    );
  }

  Future<void> _onNewTeamCreated(
    NewTeamCreated event,
    Emitter<TeamListState> emit,
  ) async {
    try {
      emit(state.copyWith(newTeamStatus: NewTeamStatus.inProgress));
      await _teamsRepository.create(state.newTeam);
      emit(state.copyWith(newTeamStatus: NewTeamStatus.success));
      add(const TeamListRequested());
    } catch (e) {
      emit(state.copyWith(newTeamStatus: NewTeamStatus.failure));
    }
  }
}
