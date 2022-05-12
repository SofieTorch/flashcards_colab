part of 'deck_room_bloc.dart';

enum RequestStatus { intial, loading, success, failure }
enum NewRoomStatus { initial, inProgress, success, failure }
enum JoinRoomRequestStatus { initial, inProgress, success, failure }

class DeckRoomState extends Equatable {
  const DeckRoomState({
    this.room = Room.empty,
    this.newRoomStatus = NewRoomStatus.initial,
    this.requestStatus = RequestStatus.intial,
    this.joinRoomStatus = JoinRoomRequestStatus.initial,
  });

  final Room room;
  final NewRoomStatus newRoomStatus;
  final RequestStatus requestStatus;
  final JoinRoomRequestStatus joinRoomStatus;

  DeckRoomState copyWith({
    Room? room,
    NewRoomStatus? newRoomStatus,
    RequestStatus? requestStatus,
    JoinRoomRequestStatus? joinRoomStatus,
  }) {
    return DeckRoomState(
      room: room ?? this.room,
      newRoomStatus: newRoomStatus ?? this.newRoomStatus,
      requestStatus: requestStatus ?? this.requestStatus,
      joinRoomStatus: joinRoomStatus ?? this.joinRoomStatus,
    );
  }

  @override
  List<Object> get props => [
        room,
        newRoomStatus,
        requestStatus,
        joinRoomStatus,
      ];
}
