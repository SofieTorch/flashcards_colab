import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards_colab/data/repositories/flashcards_repository.dart';
import 'package:flashcards_colab/models/models.dart';

part 'flashcard_event.dart';
part 'flashcard_state.dart';

class FlashcardBloc extends Bloc<FlashcardEvent, FlashcardState> {
  FlashcardBloc({
    required Flashcard flashcard,
    required this.flashcardsRepository,
  }) : super(FlashcardState(flashcard: flashcard)) {
    on<FlashcardFrontChanged>(_onFrontChanged);
    on<FlashcardBackChanged>(_onBackChanged);
  }

  final FlashcardsRepository flashcardsRepository;

  void _onFrontChanged(
    FlashcardFrontChanged event,
    Emitter<FlashcardState> emit,
  ) {
    emit(
      state.copyWith(
        flashcard: state.flashcard.copyWith(front: event.front),
      ),
    );
  }

  void _onBackChanged(
    FlashcardBackChanged event,
    Emitter<FlashcardState> emit,
  ) {
    emit(
      state.copyWith(
        flashcard: state.flashcard.copyWith(back: event.back),
      ),
    );
  }
}
