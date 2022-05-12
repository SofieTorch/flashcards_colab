part of 'study_room_bloc.dart';

abstract class StudyRoomEvent extends Equatable {
  const StudyRoomEvent();

  @override
  List<Object> get props => [];
}

class FlashcardRequested extends StudyRoomEvent {
  const FlashcardRequested();
}

class FlashcardAnswered extends StudyRoomEvent {
  const FlashcardAnswered(this.weight);
  final int weight;
}

class ShowAnswerRequested extends StudyRoomEvent {
  const ShowAnswerRequested();
}

class RoomUpdated extends StudyRoomEvent {
  const RoomUpdated(this.room);
  final Room room;
}

class FlashcardUpdated extends StudyRoomEvent {
  const FlashcardUpdated();
}

class RoomDeleted extends StudyRoomEvent {
  const RoomDeleted();
}

class RoomLeft extends StudyRoomEvent {
  const RoomLeft();
}
