import 'package:appwrite/appwrite.dart';
import 'package:flashcards_colab/data/repositories/repositories.dart';
import 'package:flashcards_colab/data/repositories/rooms_repository.dart';
import 'package:flashcards_colab/models/models.dart';
import 'package:flashcards_colab/study/widgets/widgets.dart';
import 'package:flashcards_colab/study_room/bloc/study_room_bloc.dart';
import 'package:flashcards_colab/study_room/study_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudyRoomPage extends StatelessWidget {
  const StudyRoomPage({
    required this.room,
    this.deck,
    Key? key,
  }) : super(key: key);

  final Room room;
  final Deck? deck;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudyRoomBloc>(
      create: (context) => StudyRoomBloc(
        room: room,
        flashcardsRepository: FlashcardsRepository(
          client: context.read<Client>(),
          currentUser: context.read<AuthenticationRepository>().currentUser,
        ),
        roomsRepository: RoomsRepository(
          client: context.read<Client>(),
        ),
        deck: deck,
      )..add(const FlashcardRequested()),
      child: _StudyRoomView(isHost: deck != null),
    );
  }
}

class _StudyRoomView extends StatelessWidget {
  const _StudyRoomView({required this.isHost, Key? key}) : super(key: key);
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isHost) {
          return (await showDialog<bool>(
                context: context,
                builder: (_) => BlocProvider<StudyRoomBloc>.value(
                  value: context.read<StudyRoomBloc>(),
                  child: const DeleteRoomDialog(),
                ),
              )) ??
              false;
        } else {
          return (await showDialog<bool>(
                context: context,
                builder: (_) => BlocProvider<StudyRoomBloc>.value(
                  value: context.read<StudyRoomBloc>(),
                  child: const LeftRoomDialog(),
                ),
              )) ??
              false;
        }
      },
      child: BlocListener<StudyRoomBloc, StudyRoomState>(
        listener: (context, state) {
          if (state.deleteRoomStatus == DeleteRoomStatus.success) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox.expand(),
                BlocBuilder<StudyRoomBloc, StudyRoomState>(
                  builder: (context, state) {
                    if (state.firstFlashcardStatus !=
                        RetrieveFirstFlashcardStatus.success) {
                      return const CircularProgressIndicator();
                    }

                    if (state.deckFinished) {
                      return const DeckFinishedMessage();
                    }

                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FlashcardView(content: state.content),
                          if (state.content == state.currentFlashcard.front)
                            ElevatedButton(
                              onPressed: () => context
                                  .read<StudyRoomBloc>()
                                  .add(const ShowAnswerRequested()),
                              child: const Text('Show answer'),
                            )
                          else
                            const _AnswerButtons(),
                          const SizedBox(height: 22),
                        ],
                      ),
                    );
                  },
                ),
                if (isHost)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: ElevatedButton(
                      onPressed: () => showDialog<bool>(
                        context: context,
                        builder: (_) => BlocProvider<StudyRoomBloc>.value(
                          value: context.read<StudyRoomBloc>(),
                          child: const DeleteRoomDialog(),
                        ),
                      ),
                      child: const Text('End study session'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnswerButtons extends StatelessWidget {
  const _AnswerButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudyRoomBloc, StudyRoomState>(
      builder: (context, state) {
        if (state.flashcardAnswerStatus == SendFlashcardAnswerStatus.success) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Text(
                      'Please wait until all members respond :)',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const AnswerButtons();
        }
      },
    );
  }
}
