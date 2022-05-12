import 'package:flashcards_colab/study_room/study_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeftRoomDialog extends StatelessWidget {
  const LeftRoomDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.read<StudyRoomBloc>().add(const RoomLeft());
            Navigator.pop(context, true);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            foregroundColor: MaterialStateProperty.all(Colors.red),
          ),
          child: const Text('Yes, left room'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: const Text('No, return to room'),
        ),
      ],
      content: Text(
        'You are about to left the study room! Are you sure?',
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
