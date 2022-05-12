part of 'study_bloc.dart';

enum TodayFlashcardsStatus { initial, loading, failure, success }
enum UpdateRecallStatus { initial, inProgress, failure, success }

class StudyState extends Equatable {
  const StudyState({
    this.flashcards = const <Flashcard>[],
    this.currentFlashcard = Flashcard.empty,
    this.status = TodayFlashcardsStatus.initial,
    this.updateRecallStatus = UpdateRecallStatus.initial,
    this.flashcardContent = '',
  });

  final List<Flashcard> flashcards;
  final TodayFlashcardsStatus status;
  final UpdateRecallStatus updateRecallStatus;
  final Flashcard currentFlashcard;
  final String flashcardContent;

  StudyState copyWith({
    List<Flashcard>? flashcards,
    Flashcard? currentFlashcard,
    TodayFlashcardsStatus? status,
    UpdateRecallStatus? updateRecallStatus,
    String? flashcardContent,
  }) {
    return StudyState(
      flashcards: flashcards ?? this.flashcards,
      currentFlashcard: currentFlashcard ?? this.currentFlashcard,
      status: status ?? this.status,
      updateRecallStatus: updateRecallStatus ?? this.updateRecallStatus,
      flashcardContent: flashcardContent ?? this.flashcardContent,
    );
  }

  @override
  List<Object> get props => [
        flashcards,
        status,
        updateRecallStatus,
        currentFlashcard,
        flashcardContent,
      ];
}
