part of 'flashcard_bloc.dart';

class FlashcardState extends Equatable {
  const FlashcardState({
    required this.flashcard,
  });

  final Flashcard flashcard;

  FlashcardState copyWith({
    Flashcard? flashcard,
  }) {
    return FlashcardState(
      flashcard: flashcard ?? this.flashcard,
    );
  }

  @override
  List<Object> get props => [flashcard];
}
