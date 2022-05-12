import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards_colab/data/repositories/rooms_repository.dart';
import 'package:flashcards_colab/models/models.dart';

part 'deck_room_event.dart';
part 'deck_room_state.dart';

class DeckRoomBloc extends Bloc<DeckRoomEvent, DeckRoomState> {
  DeckRoomBloc({
    required RoomsRepository roomsRepository,
  })  : _roomsRepository = roomsRepository,
        super(const DeckRoomState()) {
    on<DeckRoomRequested>(_onDeckRoomRequested);
    on<DeckRoomChanged>(_onDeckRoomChanged);
    on<DeckRoomCreated>(_onDeckRoomCreated);
    on<JoinDeckRoomRequested>(_onJoinDeckRoomRequested);
  }

  final RoomsRepository _roomsRepository;
  StreamSubscription<Room>? _roomSubscription;

  @override
  Future<void> close() {
    _roomSubscription?.cancel();
    _roomsRepository.dispose();
    return super.close();
  }

  Future<void> _onDeckRoomRequested(
    DeckRoomRequested event,
    Emitter<DeckRoomState> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final room = await _roomsRepository.getByDeck(event.deck.id);
    emit(state.copyWith(room: room, requestStatus: RequestStatus.success));

    _roomsRepository.subscribeToDeckRoom(event.deck.id);
    _roomSubscription = _roomsRepository.deckRoomStream.listen((event) {
      add(DeckRoomChanged(event));
    });
  }

  void _onDeckRoomChanged(
    DeckRoomChanged event,
    Emitter<DeckRoomState> emit,
  ) {
    emit(state.copyWith(room: event.room));
  }

  Future<void> _onDeckRoomCreated(
    DeckRoomCreated event,
    Emitter<DeckRoomState> emit,
  ) async {
    final room = Room(
      id: '',
      deckId: event.deck.id,
      currentFlashcardId: event.deck.flashcards[0].id!,
    );

    try {
      emit(state.copyWith(newRoomStatus: NewRoomStatus.inProgress));
      final newRoom =
          await _roomsRepository.createRoom(room, event.deck.ownerId);
      emit(
        state.copyWith(
          newRoomStatus: NewRoomStatus.success,
          room: newRoom,
        ),
      );
    } catch (e) {
      emit(state.copyWith(newRoomStatus: NewRoomStatus.failure));
    }
  }

  Future<void> _onJoinDeckRoomRequested(
    JoinDeckRoomRequested event,
    Emitter<DeckRoomState> emit,
  ) async {
    try {
      emit(state.copyWith(joinRoomStatus: JoinRoomRequestStatus.inProgress));
      await _roomsRepository.joinRoom(state.room);
      emit(state.copyWith(joinRoomStatus: JoinRoomRequestStatus.success));
    } catch (e) {
      emit(state.copyWith(joinRoomStatus: JoinRoomRequestStatus.failure));
    }
  }
}
