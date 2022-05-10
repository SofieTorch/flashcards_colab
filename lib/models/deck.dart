import 'package:equatable/equatable.dart';
import 'package:flashcards_colab/models/models.dart';

enum DeckType { personal, team }

class Deck extends Equatable {
  const Deck({
    required this.title,
    this.cardsCount = 0,
    this.id = '',
    this.flashcards = const [],
    this.type = DeckType.personal,
    this.ownerId = '',
  });

  final String title;
  final int cardsCount;
  final String id;
  final List<Flashcard> flashcards;
  final DeckType type;
  final String ownerId;

  static const empty = Deck(title: '');

  bool get isEmpty => this == Deck.empty;
  bool get isNotEmpty => this != Deck.empty;

  Deck copyWith({
    String? id,
    String? title,
    int? cardsCount,
    List<Flashcard>? flashcards,
    DeckType? type,
    String? ownerId,
  }) {
    return Deck(
      id: id ?? this.id,
      title: title ?? this.title,
      cardsCount: cardsCount ?? this.cardsCount,
      flashcards: flashcards ?? this.flashcards,
      type: type ?? this.type,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  @override
  List<Object?> get props => [
        title,
        cardsCount,
        id,
        flashcards,
        type,
        ownerId,
      ];
}
