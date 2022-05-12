import 'package:flashcards_colab/study/study.dart';
import 'package:flashcards_colab/theme/theme.dart';
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
              context.read<StudyBloc>().add(const FlashcardAnswered(0)),
          text: 'Forgotten',
          icon: '❌',
        ),
        AnswerButton(
          onPressed: () =>
              context.read<StudyBloc>().add(const FlashcardAnswered(1)),
          text: 'Partially recalled',
          icon: '🤨',
        ),
        AnswerButton(
          onPressed: () =>
              context.read<StudyBloc>().add(const FlashcardAnswered(2)),
          text: 'Recalled with effort',
          icon: '😌',
        ),
        AnswerButton(
          onPressed: () =>
              context.read<StudyBloc>().add(const FlashcardAnswered(3)),
          text: 'Immediately',
          icon: '🌟',
        ),
      ],
    );
  }
}

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    required this.onPressed,
    required this.text,
    required this.icon,
    Key? key,
  }) : super(key: key);

  final void Function() onPressed;
  final String text;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.snuff),
        foregroundColor: MaterialStateProperty.all(AppColors.body),
        padding: MaterialStateProperty.all(const EdgeInsets.all(4)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon),
            const SizedBox(height: 4),
            Text(text),
          ],
        ),
      ),
    );
  }
}
