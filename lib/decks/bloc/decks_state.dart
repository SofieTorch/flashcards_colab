part of 'decks_bloc.dart';

enum DecksStatus { initial, success, failure }

class DecksState extends Equatable {
  const DecksState({
    this.status = DecksStatus.initial,
    this.decks = const <Deck>[],
    this.hasReachedMax = false,
  });

  final List<Deck> decks;
  final DecksStatus status;
  final bool hasReachedMax;

  DecksState copyWith({
    DecksStatus? status,
    List<Deck>? decks,
    bool? hasReachedMax,
  }) {
    return DecksState(
      status: status ?? this.status,
      decks: decks ?? this.decks,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [status, decks, hasReachedMax];
}
