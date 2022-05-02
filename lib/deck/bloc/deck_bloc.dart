import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards_colab/data/repositories/flashcards_repository.dart';
import 'package:flashcards_colab/models/models.dart';

part 'deck_event.dart';
part 'deck_state.dart';

class DeckBloc extends Bloc<DeckEvent, DeckState> {
  DeckBloc({
    required Deck deck,
    required this.flashcardsRepository,
  }) : super(DeckState(deck: deck)) {
    on<FlashcardsRequested>(_onFlashcardsRequested);
  }

  final FlashcardsRepository flashcardsRepository;

  Future<void> _onFlashcardsRequested(
    FlashcardsRequested event,
    Emitter<DeckState> emit,
  ) async {
    emit(state.copyWith(status: FlashcardsStatus.loading));
    final flashcards = await flashcardsRepository.getFlashcards(state.deck);
    emit(
      state.copyWith(
        deck: state.deck.copyWith(flashcards: flashcards),
        status: FlashcardsStatus.success,
      ),
    );
  }
}
