import 'package:flashcards_colab/app/router.dart';
import 'package:flashcards_colab/theme/theme.dart';
import 'package:flutter/material.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Welcome! Sign in to start learning',
                style: AppTextStyle.headline2.copyWith(
                  color: AppColors.indigo.shade900,
                ),
              ),
              const _SignInForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignInForm extends StatelessWidget {
  const _SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('E-mail', style: AppTextStyle.subtitle1),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'joe@example.com',
            ),
          ),
          const SizedBox(height: 8),
          Text('Password', style: AppTextStyle.subtitle1),
          TextFormField(),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('SIGN IN'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('SIGN IN WITH GOOGLE'),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pushNamed(
                context,
                AppRouter.signUp,
              ),
              child: const Text('Not registered yet? Sign up'),
            ),
          )
        ],
      ),
    );
  }
}
