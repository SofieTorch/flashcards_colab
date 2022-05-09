import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards_colab/data/repositories/decks_repository.dart';
import 'package:flashcards_colab/models/models.dart';

part 'decks_event.dart';
part 'decks_state.dart';

class DecksBloc extends Bloc<DecksEvent, DecksState> {
  DecksBloc({
    required DecksRepository decksRepository,
  })  : _decksRepository = decksRepository,
        super(const DecksState()) {
    on<DecksRequested>(_onDecksRequested);
    on<NewDeckTitleChanged>(_onNewDeckTitleChanged);
    on<NewDeckCreated>(_onNewDeckCreated);
  }

  final DecksRepository _decksRepository;
  String? teamId;

  Future<void> _onDecksRequested(
    DecksRequested event,
    Emitter<DecksState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == DecksStatus.initial) {
        final decks = teamId == null
            ? await _decksRepository.getPersonalDecks()
            : await _decksRepository.getTeamDecks(teamId: teamId!);
        return emit(
          state.copyWith(
            status: DecksStatus.success,
            decks: decks,
            hasReachedMax: false,
          ),
        );
      }

      final decks = teamId == null
          ? await _decksRepository.getPersonalDecks(
              offset: state.decks.length,
            )
          : await _decksRepository.getTeamDecks(
              teamId: teamId!,
              offset: state.decks.length,
            );

      decks.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: DecksStatus.success,
                decks: decks,
                hasReachedMax: false,
              ),
            );
    } catch (e) {
      emit(state.copyWith(status: DecksStatus.failure));
    }
  }

  void _onNewDeckTitleChanged(
    NewDeckTitleChanged event,
    Emitter<DecksState> emit,
  ) {
    emit(
      state.copyWith(
        newDeck: state.newDeck.copyWith(title: event.title),
      ),
    );
  }

  Future<void> _onNewDeckCreated(
    NewDeckCreated event,
    Emitter<DecksState> emit,
  ) async {
    try {
      emit(state.copyWith(newDeckStatus: NewDeckStatus.inProgress));

      await _decksRepository.createDeck(
        title: state.newDeck.title,
        teamId: teamId,
      );

      emit(
        state.copyWith(
          newDeckStatus: NewDeckStatus.success,
          status: DecksStatus.initial,
        ),
      );
      add(DecksRequested());
    } catch (e) {
      emit(state.copyWith(newDeckStatus: NewDeckStatus.failure));
    }
  }
}
