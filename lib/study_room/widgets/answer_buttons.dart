import 'package:flashcards_colab/study/widgets/widgets.dart';
import 'package:flashcards_colab/study_room/study_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnswerButtons extends StatelessWidget {
  const AnswerButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      crossAxisCount: 2,
      childAspectRatio: 2.5 / 1,
      shrinkWrap: true,
      children: [
        AnswerButton(
          onPressed: () =>
              context.read<StudyRoomBloc>().add(const FlashcardAnswered(0)),
          text: 'Forgotten',
          icon: '❌',
        ),
        AnswerButton(
          onPressed: () =>
              context.read<StudyRoomBloc>().add(const FlashcardAnswered(1)),
          text: 'Partially recalled',
          icon: '🤨',
        ),
        AnswerButton(
          onPressed: () =>
              context.read<StudyRoomBloc>().add(const FlashcardAnswered(2)),
          text: 'Recalled with effort',
          icon: '😌',
        ),
        AnswerButton(
          onPressed: () =>
              context.read<StudyRoomBloc>().add(const FlashcardAnswered(3)),
          text: 'Immediately',
          icon: '🌟',
        ),
      ],
    );
  }
}

class AnswerButtonsInactive extends StatelessWidget {
  const AnswerButtonsInactive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      crossAxisCount: 2,
      childAspectRatio: 2.5 / 1,
      shrinkWrap: true,
      children: const [
        AnswerButton(
          text: 'Forgotten',
          icon: '❌',
        ),
        AnswerButton(
          text: 'Partially recalled',
          icon: '🤨',
        ),
        AnswerButton(
          text: 'Recalled with effort',
          icon: '😌',
        ),
        AnswerButton(
          text: 'Immediately',
          icon: '🌟',
        ),
      ],
    );
  }
}
