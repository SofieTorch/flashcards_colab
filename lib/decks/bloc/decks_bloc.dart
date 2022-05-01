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
  }

  final DecksRepository _decksRepository;

  Future<void> _onDecksRequested(
    DecksRequested event,
    Emitter<DecksState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == DecksStatus.initial) {
        final decks = await _decksRepository.getPersonalDecks();
        return emit(
          state.copyWith(
            status: DecksStatus.success,
            decks: decks,
            hasReachedMax: false,
          ),
        );
      }

      final decks = await _decksRepository.getPersonalDecks(
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

  Future<void> _onDeckCreated(
    DeckCreated event,
    Emitter<DecksState> emit,
  ) async {}
}
