import 'package:flashcards_colab/flashcard/bloc/flashcard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardForm extends StatelessWidget {
  const FlashcardForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _FrontInput(),
        SizedBox(height: 8),
        _BackInput(),
      ],
    );
  }
}

class _FrontInput extends StatelessWidget {
  const _FrontInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (front) =>
          context.read<FlashcardBloc>().add(FlashcardFrontChanged(front)),
    );
  }
}

class _BackInput extends StatelessWidget {
  const _BackInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (back) =>
          context.read<FlashcardBloc>().add(FlashcardBackChanged(back)),
    );
  }
}
