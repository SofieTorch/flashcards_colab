part of 'deck_bloc.dart';

enum FlashcardsStatus { initial, loading, success, failure }

class DeckState extends Equatable {
  const DeckState({
    this.status = FlashcardsStatus.initial,
    required this.deck,
  });

  final FlashcardsStatus status;
  final Deck deck;

  DeckState copyWith({
    FlashcardsStatus? status,
    Deck? deck,
  }) {
    return DeckState(
      deck: deck ?? this.deck,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [deck, status];
}
