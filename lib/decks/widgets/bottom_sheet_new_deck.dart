import 'package:flashcards_colab/decks/decks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomSheetNewDeck extends StatelessWidget {
  const BottomSheetNewDeck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: mediaQueryData.viewInsets,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Deck's title:"),
            _DeckTitleInput(),
            SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: _CreateDeckButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeckTitleInput extends StatelessWidget {
  const _DeckTitleInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (title) =>
          context.read<DecksBloc>().add(NewDeckTitleChanged(title)),
    );
  }
}

class _CreateDeckButton extends StatelessWidget {
  const _CreateDeckButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DecksBloc, DecksState>(
      builder: (context, state) {
        return state.newDeckStatus == NewDeckStatus.inProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () =>
                    context.read<DecksBloc>().add(const NewDeckCreated()),
                child: const Text('Create deck'),
              );
      },
    );
  }
}
