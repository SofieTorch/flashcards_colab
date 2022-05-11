import 'package:appwrite/appwrite.dart';
import 'package:flashcards_colab/data/repositories/repositories.dart';
import 'package:flashcards_colab/study/study.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudyPage extends StatelessWidget {
  const StudyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudyBloc>(
      create: (context) => StudyBloc(
        flashcardsRepository: FlashcardsRepository(
          client: context.read<Client>(),
          currentUser: context.read<AuthenticationRepository>().currentUser,
        ),
      )..add(TodayFlashcardsRequested()),
      child: const _StudyView(),
    );
  }
}

class _StudyView extends StatelessWidget {
  const _StudyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<StudyBloc, StudyState>(
        builder: (context, state) {
          if (state.status == TodayFlashcardsStatus.success) {
            if (state.flashcards.isEmpty) {
              return const Text("You're done for today!");
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.flashcardContent),
                if (state.flashcardContent == state.currentFlashcard.front)
                  ElevatedButton(
                    onPressed: () =>
                        context.read<StudyBloc>().add(ShowAnswerRequested()),
                    child: const Text('Show answer'),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => context
                            .read<StudyBloc>()
                            .add(const FlashcardAnswered(0)),
                        child: const Text('0'),
                      ),
                      ElevatedButton(
                        onPressed: () => context
                            .read<StudyBloc>()
                            .add(const FlashcardAnswered(1)),
                        child: const Text('1'),
                      ),
                      ElevatedButton(
                        onPressed: () => context
                            .read<StudyBloc>()
                            .add(const FlashcardAnswered(2)),
                        child: const Text('2'),
                      ),
                      ElevatedButton(
                        onPressed: () => context
                            .read<StudyBloc>()
                            .add(const FlashcardAnswered(3)),
                        child: const Text('3'),
                      ),
                    ],
                  ),
              ],
            );
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
