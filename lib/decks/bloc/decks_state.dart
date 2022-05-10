part of 'decks_bloc.dart';

enum DecksStatus { initial, loading, success, failure }
enum NewDeckStatus { initial, inProgress, success, failure }

class DecksState extends Equatable {
  const DecksState({
    this.status = DecksStatus.initial,
    this.decks = const <Deck>[],
    this.hasReachedMax = false,
    this.newDeck = Deck.empty,
    this.newDeckStatus = NewDeckStatus.initial,
  });

  final List<Deck> decks;
  final DecksStatus status;
  final bool hasReachedMax;
  final Deck newDeck;
  final NewDeckStatus newDeckStatus;

  DecksState copyWith({
    DecksStatus? status,
    List<Deck>? decks,
    bool? hasReachedMax,
    Deck? newDeck,
    NewDeckStatus? newDeckStatus,
  }) {
    return DecksState(
      status: status ?? this.status,
      decks: decks ?? this.decks,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      newDeck: newDeck ?? this.newDeck,
      newDeckStatus: newDeckStatus ?? this.newDeckStatus,
    );
  }

  @override
  List<Object> get props => [
        status,
        decks,
        hasReachedMax,
        newDeck,
        newDeckStatus,
      ];
}
