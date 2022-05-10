part of 'flashcard_bloc.dart';

abstract class FlashcardEvent extends Equatable {
  const FlashcardEvent();

  @override
  List<Object> get props => [];
}

class FlashcardFrontChanged extends FlashcardEvent {
  const FlashcardFrontChanged(this.front);

  final String front;

  @override
  List<Object> get props => [front];
}

class FlashcardBackChanged extends FlashcardEvent {
  const FlashcardBackChanged(this.back);

  final String back;

  @override
  List<Object> get props => [back];
}
