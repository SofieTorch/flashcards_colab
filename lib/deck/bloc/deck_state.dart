part of 'deck_bloc.dart';

enum FlashcardsStatus { initial, loading, success, failure }
enum NewFlashcardStatus { initial, inProgress, success, failure }

class DeckState extends Equatable {
  const DeckState({
    required this.deck,
    this.status = FlashcardsStatus.initial,
    this.newFlashcardStatus = NewFlashcardStatus.initial,
  });

  final Deck deck;
  final FlashcardsStatus status;
  final NewFlashcardStatus newFlashcardStatus;

  DeckState copyWith({
    Deck? deck,
    FlashcardsStatus? status,
    NewFlashcardStatus? newFlashcardStatus,
  }) {
    return DeckState(
      deck: deck ?? this.deck,
      status: status ?? this.status,
      newFlashcardStatus: newFlashcardStatus ?? this.newFlashcardStatus,
    );
  }

  @override
  List<Object> get props => [deck, status, newFlashcardStatus];
}
