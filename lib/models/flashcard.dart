import 'package:equatable/equatable.dart';

part 'recall.dart';

class Flashcard extends Equatable {
  const Flashcard({
    this.front = '',
    this.back = '',
    this.deckId = '',
    this.id,
    this.recall,
  });

  final String front;
  final String back;
  final String deckId;
  final String? id;
  final Recall? recall;

  static const empty = Flashcard(id: '');

  bool get isEmpty => this == Flashcard.empty;
  bool get isNotEmpty => this != Flashcard.empty;

  Flashcard copyWith({
    String? front,
    String? back,
    String? deckId,
    String? id,
    Recall? recall,
  }) {
    return Flashcard(
      front: front ?? this.front,
      back: back ?? this.back,
      deckId: deckId ?? this.deckId,
      id: id ?? this.id,
      recall: recall ?? this.recall,
    );
  }

  @override
  List<Object?> get props => [front, back, deckId, id, recall];
}
