part of 'deck_bloc.dart';

abstract class DeckEvent extends Equatable {
  const DeckEvent();

  @override
  List<Object> get props => [];
}

class FlashcardsRequested extends DeckEvent {}

class FlashcardCreated extends DeckEvent {
  const FlashcardCreated(this.flashcard);
  final Flashcard flashcard;
}

class FlashcardListChanged extends DeckEvent {
  const FlashcardListChanged(this.flashcard);
  final Flashcard flashcard;
}
