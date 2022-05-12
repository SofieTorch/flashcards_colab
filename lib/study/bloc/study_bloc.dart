import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards_colab/data/repositories/repositories.dart';
import 'package:flashcards_colab/models/models.dart';

part 'study_event.dart';
part 'study_state.dart';

class StudyBloc extends Bloc<StudyEvent, StudyState> {
  StudyBloc({required FlashcardsRepository flashcardsRepository})
      : _flashcardsRepository = flashcardsRepository,
        super(const StudyState()) {
    on<TodayFlashcardsRequested>(_onTodayFlashcardsRequested);
    on<FlashcardAnswered>(_onFlashcardAnswered);
    on<ShowAnswerRequested>(_onShowAnswerRequested);
  }

  final FlashcardsRepository _flashcardsRepository;

  Future<void> _onTodayFlashcardsRequested(
    TodayFlashcardsRequested event,
    Emitter<StudyState> emit,
  ) async {
    emit(state.copyWith(status: TodayFlashcardsStatus.loading));
    final flashcards = await _flashcardsRepository.getTodayFlashcards();
    emit(
      state.copyWith(
        status: TodayFlashcardsStatus.success,
        flashcards: flashcards,
        currentFlashcard: flashcards[0],
        flashcardContent: flashcards[0].front,
      ),
    );
  }

  Future<void> _onFlashcardAnswered(
    FlashcardAnswered event,
    Emitter<StudyState> emit,
  ) async {
    emit(state.copyWith(updateRecallStatus: UpdateRecallStatus.inProgress));
    await _flashcardsRepository.updateFlashcardRecall(
      flashcard: state.currentFlashcard,
      weight: event.weight,
    );

    final flashcardsCopy = List<Flashcard>.from(state.flashcards)..removeAt(0);
    Flashcard nextFlashcard;
    try {
      nextFlashcard = flashcardsCopy[0];
    } catch (e) {
      nextFlashcard = Flashcard.empty;
    }

    emit(
      state.copyWith(
        updateRecallStatus: UpdateRecallStatus.success,
        flashcards: flashcardsCopy,
        currentFlashcard: nextFlashcard,
        flashcardContent: nextFlashcard.front,
      ),
    );
  }

  void _onShowAnswerRequested(
    ShowAnswerRequested event,
    Emitter<StudyState> emit,
  ) {
    emit(state.copyWith(flashcardContent: state.currentFlashcard.back));
  }
}
