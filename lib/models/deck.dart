import 'package:equatable/equatable.dart';
import 'package:flashcards_colab/models/models.dart';

class Deck extends Equatable {
  const Deck({
    required this.title,
    this.cardsCount = 0,
    this.id = '',
    this.flashcards = const [],
  });

  final String title;
  final int cardsCount;
  final String id;
  final List<Flashcard> flashcards;

  Deck copyWith({
    String? title,
    int? cardsCount,
    List<Flashcard>? flashcards,
    String? id,
  }) {
    return Deck(
      title: title ?? this.title,
      cardsCount: cardsCount ?? this.cardsCount,
      flashcards: flashcards ?? this.flashcards,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [title, cardsCount, id, flashcards];
}
