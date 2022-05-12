import 'package:equatable/equatable.dart';

class Room extends Equatable {
  const Room({
    required this.id,
    required this.deckId,
    required this.currentFlashcardId,
    this.attendeesCount = 1,
    this.answersCount = 0,
  });

  final String id;
  final String deckId;
  final String currentFlashcardId;
  final int attendeesCount;
  final int answersCount;

  static const empty = Room(
    id: '',
    deckId: '',
    currentFlashcardId: '',
  );

  bool get isEmpty => empty == this;
  bool get isNotEmpty => empty != this;

  Room copyWith({
    String? id,
    String? deckId,
    String? currentFlashcardId,
    int? attendeesCount,
    int? answersCount,
  }) {
    return Room(
      id: id ?? this.id,
      deckId: deckId ?? this.id,
      currentFlashcardId: currentFlashcardId ?? this.currentFlashcardId,
      attendeesCount: attendeesCount ?? this.attendeesCount,
      answersCount: answersCount ?? this.answersCount,
    );
  }

  @override
  List<Object?> get props => [id, deckId, attendeesCount, answersCount];
}
