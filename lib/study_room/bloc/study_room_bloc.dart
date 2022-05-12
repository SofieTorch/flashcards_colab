import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards_colab/data/repositories/repositories.dart';
import 'package:flashcards_colab/data/repositories/rooms_repository.dart';
import 'package:flashcards_colab/models/models.dart';

part 'study_room_event.dart';
part 'study_room_state.dart';

class StudyRoomBloc extends Bloc<StudyRoomEvent, StudyRoomState> {
  StudyRoomBloc({
    required Room room,
    required FlashcardsRepository flashcardsRepository,
    required RoomsRepository roomsRepository,
    Deck? deck,
  })  : _flashcardsRepository = flashcardsRepository,
        _roomsRepository = roomsRepository,
        super(
          StudyRoomState(
            room: room,
            deck: deck ?? Deck.empty,
          ),
        ) {
    on<FlashcardRequested>(_onFlashcardRequested);
    on<ShowAnswerRequested>(_onShowAnswerRequested);
    on<FlashcardAnswered>(_onFlashcardAnswered);
    on<RoomUpdated>(_onRoomUpdated);
    on<FlashcardUpdated>(_onFlashcardUpdated);
    on<RoomDeleted>(_onRoomDeleted);
    on<RoomLeft>(_onRoomLeft);
  }

  final FlashcardsRepository _flashcardsRepository;
  final RoomsRepository _roomsRepository;
  late StreamSubscription<Room> _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    _roomsRepository.dispose();
    _flashcardsRepository.dispose();
    return super.close();
  }

  Future<void> _onFlashcardRequested(
    FlashcardRequested event,
    Emitter<StudyRoomState> emit,
  ) async {
    emit(
      state.copyWith(
        firstFlashcardStatus: RetrieveFirstFlashcardStatus.inProgress,
      ),
    );

    final flashcard =
        await _flashcardsRepository.getFlashcard(state.room.currentFlashcardId);
    emit(
      state.copyWith(
        content: flashcard.front,
        currentFlashcard: flashcard,
        firstFlashcardStatus: RetrieveFirstFlashcardStatus.success,
      ),
    );

    _roomsRepository.subscribeToRoom(state.room);
    _subscription = _roomsRepository.roomStream.listen((room) {
      add(RoomUpdated(room));
    });
  }

  void _onShowAnswerRequested(
    ShowAnswerRequested event,
    Emitter<StudyRoomState> emit,
  ) {
    emit(state.copyWith(content: state.currentFlashcard.back));
  }

  Future<void> _onFlashcardAnswered(
    FlashcardAnswered event,
    Emitter<StudyRoomState> emit,
  ) async {
    emit(
      state.copyWith(
        flashcardAnswerStatus: SendFlashcardAnswerStatus.inProgress,
      ),
    );

    await _flashcardsRepository.updateFlashcardRecall(
      flashcard: state.currentFlashcard,
      weight: event.weight,
    );

    await _roomsRepository.answerFlashcard(
      state.room.id,
      state.room.answersCount,
    );

    emit(
      state.copyWith(
        flashcardAnswerStatus: SendFlashcardAnswerStatus.success,
      ),
    );
  }

  Future<void> _onRoomUpdated(
    RoomUpdated event,
    Emitter<StudyRoomState> emit,
  ) async {
    final flashcardChanged =
        state.room.currentFlashcardId != event.room.currentFlashcardId;

    emit(state.copyWith(room: event.room));

    if (flashcardChanged) {
      if (state.room.currentFlashcardId.isNotEmpty) {
        final flashcard = await _flashcardsRepository
            .getFlashcard(event.room.currentFlashcardId);
        emit(
          state.copyWith(
            content: flashcard.front,
            currentFlashcard: flashcard,
            flashcardAnswerStatus: SendFlashcardAnswerStatus.initial,
          ),
        );
      } else {
        emit(state.copyWith(deckFinished: true));
      }
    }

    final answersCompleted =
        state.room.answersCount == state.room.attendeesCount;

    if (state.deck.isNotEmpty && answersCompleted) {
      add(const FlashcardUpdated());
    }
  }

  Future<void> _onFlashcardUpdated(
    FlashcardUpdated event,
    Emitter<StudyRoomState> emit,
  ) async {
    final flashcardsCopy = List<Flashcard>.from(state.deck.flashcards)
      ..removeAt(0);

    Flashcard nextFlashcard;
    try {
      nextFlashcard = flashcardsCopy[0];
    } catch (e) {
      nextFlashcard = Flashcard.empty;
    }

    emit(
      state.copyWith(
        updateFlashcardStatus: UpdateFlashcardStatus.inProgress,
      ),
    );

    await _roomsRepository.updateFlashcard(
      state.room.id,
      nextFlashcard.id!,
    );

    emit(
      state.copyWith(
        updateFlashcardStatus: UpdateFlashcardStatus.success,
        deck: state.deck.copyWith(flashcards: flashcardsCopy),
      ),
    );
  }

  Future<void> _onRoomDeleted(
    RoomDeleted event,
    Emitter<StudyRoomState> emit,
  ) async {
    emit(state.copyWith(deleteRoomStatus: DeleteRoomStatus.inProgress));
    await _roomsRepository.delete(state.room.id);
    emit(state.copyWith(deleteRoomStatus: DeleteRoomStatus.success));
  }

  Future<void> _onRoomLeft(
    RoomLeft event,
    Emitter<StudyRoomState> emit,
  ) async {
    emit(state.copyWith(leftRoomStatus: LeftRoomStatus.inProgress));
    await _roomsRepository.left(state.room);
    emit(state.copyWith(leftRoomStatus: LeftRoomStatus.success));
  }
}
