import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards_colab/data/repositories/flashcards_repository.dart';
import 'package:flashcards_colab/models/models.dart';

part 'deck_event.dart';
part 'deck_state.dart';

class DeckBloc extends Bloc<DeckEvent, DeckState> {
  DeckBloc({
    required Deck deck,
    required FlashcardsRepository flashcardsRepository,
  })  : _flashcardsRepository = flashcardsRepository,
        super(DeckState(deck: deck)) {
    on<FlashcardsRequested>(_onFlashcardsRequested);
    on<FlashcardCreated>(_onFlashcardCreated);
    on<FlashcardListChanged>(_onFlashcardListChanged);
  }

  final FlashcardsRepository _flashcardsRepository;
  StreamSubscription<Flashcard>? _flashcardsSubscription;

  @override
  Future<void> close() {
    _flashcardsSubscription?.cancel();
    _flashcardsRepository.dispose();
    return super.close();
  }

  Future<void> _onFlashcardsRequested(
    FlashcardsRequested event,
    Emitter<DeckState> emit,
  ) async {
    emit(state.copyWith(status: FlashcardsStatus.loading));
    final flashcards = await _flashcardsRepository.getFlashcards(state.deck);
    emit(
      state.copyWith(
        deck: state.deck.copyWith(flashcards: flashcards),
        status: FlashcardsStatus.success,
      ),
    );

    if (state.deck.type == DeckType.team) {
      _flashcardsRepository.subscribeToFlashcards(deckId: state.deck.id);
      _flashcardsSubscription =
          _flashcardsRepository.flashcardsStream.listen((event) {
        add(FlashcardListChanged(event));
      });
    }
  }

  Future<void> _onFlashcardCreated(
    FlashcardCreated event,
    Emitter<DeckState> emit,
  ) async {
    emit(state.copyWith(newFlashcardStatus: NewFlashcardStatus.inProgress));
    await _flashcardsRepository.createFlashcard(
      flashcard: event.flashcard,
      teamId: state.deck.ownerId,
    );
    emit(state.copyWith(newFlashcardStatus: NewFlashcardStatus.success));
  }

  void _onFlashcardListChanged(
    FlashcardListChanged event,
    Emitter<DeckState> emit,
  ) {
    final flashcard = state.deck.flashcards.firstWhere(
      (element) => element.id == event.flashcard.id,
      orElse: () => Flashcard.empty,
    );
    print('Flashcard: $flashcard');
    final flashcardsCopy = List<Flashcard>.from(state.deck.flashcards);
    print(flashcardsCopy);
    print(state.deck.flashcards);
    if (flashcard.isEmpty) {
      flashcardsCopy.add(event.flashcard);
      print(flashcardsCopy);
      emit(
        state.copyWith(
          deck: state.deck.copyWith(flashcards: flashcardsCopy),
        ),
      );
      print(state.deck.flashcards);
    } else {
      flashcardsCopy[flashcardsCopy.indexOf(flashcard)] = event.flashcard;
      emit(
        state.copyWith(
          deck: state.deck.copyWith(flashcards: flashcardsCopy),
        ),
      );
    }
  }
}
