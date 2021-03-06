import 'package:appwrite/appwrite.dart';
import 'package:flashcards_colab/data/repositories/repositories.dart';
import 'package:flashcards_colab/study/study.dart';
import 'package:flashcards_colab/theme/theme.dart';
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: BlocBuilder<StudyBloc, StudyState>(
          builder: (context, state) {
            if (state.status == TodayFlashcardsStatus.success) {
              if (state.flashcards.isEmpty) {
                return const Text("You're done for today!");
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FlashcardView(content: state.flashcardContent),
                  if (state.flashcardContent == state.currentFlashcard.front)
                    ElevatedButton(
                      onPressed: () =>
                          context.read<StudyBloc>().add(ShowAnswerRequested()),
                      child: Text(
                        'Ready? Show answer',
                        style: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(color: AppColors.white),
                      ),
                    )
                  else
                    const _AnswerButtons(),
                ],
              );
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class _AnswerButtons extends StatelessWidget {
  const _AnswerButtons({Key? key}) : super(key: key);

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
          icon: '???',
        ),
        AnswerButton(
          onPressed: () =>
              context.read<StudyBloc>().add(const FlashcardAnswered(1)),
          text: 'Partially recalled',
          icon: '????',
        ),
        AnswerButton(
          onPressed: () =>
              context.read<StudyBloc>().add(const FlashcardAnswered(2)),
          text: 'Recalled with effort',
          icon: '????',
        ),
        AnswerButton(
          onPressed: () =>
              context.read<StudyBloc>().add(const FlashcardAnswered(3)),
          text: 'Immediately',
          icon: '????',
        ),
      ],
    );
  }
}
