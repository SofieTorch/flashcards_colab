import 'package:appwrite/appwrite.dart';
import 'package:flashcards_colab/data/repositories/rooms_repository.dart';
import 'package:flashcards_colab/deck/deck.dart';
import 'package:flashcards_colab/study_room/pages/study_room_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeckRoom extends StatelessWidget {
  const DeckRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeckRoomBloc>(
      create: (context) => DeckRoomBloc(
        roomsRepository: RoomsRepository(
          client: context.read<Client>(),
        ),
      )..add(DeckRoomRequested(context.read<DeckBloc>().state.deck)),
      child: const _DeckRoomView(),
    );
  }
}

class _DeckRoomView extends StatelessWidget {
  const _DeckRoomView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeckRoomBloc, DeckRoomState>(
      listenWhen: (prev, curr) {
        return prev.joinRoomStatus != curr.joinRoomStatus ||
            prev.newRoomStatus != curr.newRoomStatus ||
            prev.requestStatus != curr.requestStatus;
      },
      listener: (context, state) {
        if (state.joinRoomStatus == JoinRoomRequestStatus.success) {
          Navigator.push(
            context,
            MaterialPageRoute<Widget>(
              builder: (context) {
                return StudyRoomPage(room: state.room);
              },
            ),
          );
          return;
        }

        if (state.newRoomStatus == NewRoomStatus.success) {
          Navigator.push(
            context,
            MaterialPageRoute<Widget>(
              builder: (_) {
                return StudyRoomPage(
                  room: state.room,
                  deck: context.read<DeckBloc>().state.deck,
                );
              },
            ),
          );
          return;
        }
      },
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.success) {
          if (state.room.isEmpty) {
            return ElevatedButton(
              onPressed: () => context
                  .read<DeckRoomBloc>()
                  .add(DeckRoomCreated(context.read<DeckBloc>().state.deck)),
              child: const Text('Init study room'),
            );
          }

          if (state.room.isNotEmpty) {
            return ElevatedButton(
              onPressed: () => context
                  .read<DeckRoomBloc>()
                  .add(const JoinDeckRoomRequested()),
              child: const Text('Join room'),
            );
          }
        }

        if (state.requestStatus == RequestStatus.failure) {
          return const Text('Failed to verify room');
        }

        return const Text('Verifying room...');
      },
    );
  }
}
