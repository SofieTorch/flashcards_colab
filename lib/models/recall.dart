part of 'flashcard.dart';

class Recall extends Equatable {
  const Recall({
    this.flashcardId = '',
    this.userId = '',
    required this.nextRepetition,
    this.lastDifferenceHours = 12,
    this.id = '',
  });

  final String flashcardId;
  final String userId;
  final DateTime nextRepetition;
  final int lastDifferenceHours;
  final String id;

  @override
  List<Object?> get props => [
        flashcardId,
        userId,
        nextRepetition,
        lastDifferenceHours,
        id,
      ];
}
