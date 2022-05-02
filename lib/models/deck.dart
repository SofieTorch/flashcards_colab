import 'package:equatable/equatable.dart';

class Deck extends Equatable {
  const Deck({
    required this.title,
    this.cardsCount = 0,
    this.id,
  });

  final String title;
  final int cardsCount;
  final String? id;

  Deck copyWith({
    String? title,
    int? cardsCount,
    String? id,
  }) {
    return Deck(
      title: title ?? this.title,
      cardsCount: cardsCount ?? this.cardsCount,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [title, cardsCount, id];
}
