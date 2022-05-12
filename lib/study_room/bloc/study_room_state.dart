part of 'study_room_bloc.dart';

enum RetrieveFirstFlashcardStatus { initial, inProgress, success, failure }
enum SendFlashcardAnswerStatus { initial, inProgress, success, failure }
enum UpdateFlashcardStatus { initial, inProgress, success, failure }
enum DeleteRoomStatus { initial, inProgress, success, failure }

class StudyRoomState extends Equatable {
  const StudyRoomState({
    required this.room,
    this.currentFlashcard = Flashcard.empty,
    this.content = '',
    this.deck = Deck.empty,
    this.flashcardAnswerStatus = SendFlashcardAnswerStatus.initial,
    this.updateFlashcardStatus = UpdateFlashcardStatus.initial,
    this.firstFlashcardStatus = RetrieveFirstFlashcardStatus.initial,
    this.deleteRoomStatus = DeleteRoomStatus.initial,
    this.deckFinished = false,
  });

  final Room room;
  final Deck deck;
  final String content;
  final bool deckFinished;
  final Flashcard currentFlashcard;
  final SendFlashcardAnswerStatus flashcardAnswerStatus;
  final UpdateFlashcardStatus updateFlashcardStatus;
  final RetrieveFirstFlashcardStatus firstFlashcardStatus;
  final DeleteRoomStatus deleteRoomStatus;

  StudyRoomState copyWith({
    Room? room,
    Deck? deck,
    String? content,
    bool? deckFinished,
    Flashcard? currentFlashcard,
    SendFlashcardAnswerStatus? flashcardAnswerStatus,
    UpdateFlashcardStatus? updateFlashcardStatus,
    RetrieveFirstFlashcardStatus? firstFlashcardStatus,
    DeleteRoomStatus? deleteRoomStatus,
  }) {
    return StudyRoomState(
      room: room ?? this.room,
      deck: deck ?? this.deck,
      content: content ?? this.content,
      deckFinished: deckFinished ?? this.deckFinished,
      currentFlashcard: currentFlashcard ?? this.currentFlashcard,
      flashcardAnswerStatus:
          flashcardAnswerStatus ?? this.flashcardAnswerStatus,
      updateFlashcardStatus:
          updateFlashcardStatus ?? this.updateFlashcardStatus,
      firstFlashcardStatus: firstFlashcardStatus ?? this.firstFlashcardStatus,
      deleteRoomStatus: deleteRoomStatus ?? this.deleteRoomStatus,
    );
  }

  @override
  List<Object> get props => [
        room,
        deck,
        content,
        deckFinished,
        currentFlashcard,
        flashcardAnswerStatus,
        updateFlashcardStatus,
        firstFlashcardStatus,
        deleteRoomStatus,
      ];
}
