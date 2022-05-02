part of 'flashcard_bloc.dart';

enum FlashcardStatus { initial, inProgress, success, failure }

class FlashcardState extends Equatable {
  const FlashcardState({
    required this.flashcard,
    this.status = FlashcardStatus.initial,
  });

  final Flashcard flashcard;
  final FlashcardStatus status;

  FlashcardState copyWith({
    Flashcard? flashcard,
    FlashcardStatus? status,
  }) {
    return FlashcardState(
      flashcard: flashcard ?? this.flashcard,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [flashcard, status];
}
