// ignore_for_file: use_raw_strings

import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appw_models;
import 'package:flashcards_colab/data/providers/rooms_provider.dart';
import 'package:flashcards_colab/models/models.dart';

class RoomsRepository {
  RoomsRepository({required Client client}) : _provider = RoomsProvider(client);

  final RoomsProvider _provider;

  final _roomController = StreamController<Room>();
  final _deckController = StreamController<Room>();

  Stream<Room> get deckRoomStream async* {
    yield* _deckController.stream;
  }

  Stream<Room> get roomStream async* {
    yield* _roomController.stream;
  }

  void subscribeToDeckRoom(String deckId) {
    _provider.subscribeToDeckRoom(
      deckId: deckId,
      onData: (realtimeMessage) {
        final roomDoc = realtimeMessage.toRoomDocument;
        _deckController.add(roomDoc.toRoom);
      },
    );
  }

  Future<void> joinRoom(Room room) async {
    await _provider.updateAttendeesCount(
      room.id,
      room.attendeesCount,
    );
  }

  Future<Room> createRoom(Room room, String teamId) async {
    final doc = await _provider.create(
      teamId: teamId,
      deckId: room.deckId,
      currentFlashcardId: room.currentFlashcardId,
    );

    return doc.toRoom;
  }

  void subscribeToRoom(Room room) {
    _provider.subscribeToRoom(
      roomId: room.id,
      onData: (realtimeMessage) {
        final roomDoc = realtimeMessage.toRoomDocument;
        _roomController.add(roomDoc.toRoom);
      },
    );
  }

  Future<void> updateFlashcard(String roomId, String newFlashcardId) =>
      _provider.updateFlashcard(
        roomId: roomId,
        newFlashcardId: newFlashcardId,
      );

  Future<void> answerFlashcard(String roomId, int currentAnswersCount) =>
      _provider.updateAnswersCount(roomId, currentAnswersCount);

  Future<void> delete(String roomId) => _provider.delete(roomId);

  Future<Room> getByDeck(String deckId) async {
    try {
      final doc = await _provider.getRoomByDeck(deckId);
      return doc.toRoom;
    } catch (e) {
      return Room.empty;
    }
  }

  void dispose() {
    _roomController.close();
    _deckController.close();
    _provider.dispose();
  }
}

extension on appw_models.Document {
  Room get toRoom {
    return Room(
      id: $id,
      deckId: data['deck'] as String,
      currentFlashcardId: data['current_flashcard'] as String,
      attendeesCount: data['attendees_count'] as int,
      answersCount: data['answers_count'] as int,
    );
  }
}

extension on RealtimeMessage {
  appw_models.Document get toRoomDocument {
    final readRaw = payload['\$read'] as List<dynamic>;
    final readPermissions = readRaw.map((dynamic e) => e.toString()).toList();
    final writeRaw = payload['\$read'] as List<dynamic>;
    final writePermissions = writeRaw.map((dynamic e) => e.toString()).toList();

    return appw_models.Document(
      $id: payload['\$id'] as String,
      $collection: payload['\$collection'] as String,
      $read: readPermissions,
      $write: writePermissions,
      data: <String, dynamic>{
        'deck': payload['deck'],
        'current_flashcard': payload['current_flashcard'],
        'answers_count': payload['answers_count'],
        'attendees_count': payload['attendees_count'],
      },
    );
  }
}
