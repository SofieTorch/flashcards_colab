part of 'deck_room_bloc.dart';

abstract class DeckRoomEvent extends Equatable {
  const DeckRoomEvent();

  @override
  List<Object> get props => [];
}

class DeckRoomRequested extends DeckRoomEvent {
  const DeckRoomRequested(this.deck);
  final Deck deck;
}

class DeckRoomChanged extends DeckRoomEvent {
  const DeckRoomChanged(this.room);
  final Room room;
}

class DeckRoomCreated extends DeckRoomEvent {
  const DeckRoomCreated(this.deck);
  final Deck deck;
}

class JoinDeckRoomRequested extends DeckRoomEvent {
  const JoinDeckRoomRequested();
}
