part of 'deck_bloc.dart';

abstract class DeckEvent extends Equatable {
  const DeckEvent();

  @override
  List<Object> get props => [];
}

class FlashcardsRequested extends DeckEvent {}

class NewFlashcardFrontChanged extends DeckEvent {
  const NewFlashcardFrontChanged(this.front);

  final String front;

  @override
  List<Object> get props => [front];
}
