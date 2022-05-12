import 'package:flashcards_colab/data/repositories/authentication_repository.dart';
import 'package:flashcards_colab/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _SignUpView();
  }
}

class _SignUpView extends StatelessWidget {
  const _SignUpView({Key? key}) : super(key: key);

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
                  Column(
                    children: [
                      Text(
                        'Sign up!',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Text(
                        "Let's create an account :)",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                  BlocProvider<SignUpBloc>(
                    create: (context) {
                      return SignUpBloc(
                        authenticationRepository:
                            context.read<AuthenticationRepository>(),
                      );
                    },
                    child: const SignUpForm(),
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
