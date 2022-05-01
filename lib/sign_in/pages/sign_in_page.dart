import 'package:flashcards_colab/data/repositories/authentication_repository.dart';
import 'package:flashcards_colab/sign_in/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _SignInView();
  }
}

class _SignInView extends StatelessWidget {
  const _SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SignInHeader(),
                  BlocProvider<SignInBloc>(
                    create: (context) {
                      return SignInBloc(
                        authRepository:
                            context.read<AuthenticationRepository>(),
                      );
                    },
                    child: const SignInForm(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
