import 'package:flashcards_colab/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _ProfileView();
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your info should be here... soon!',
              style: Theme.of(context).textTheme.headline3,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () =>
                  context.read<AuthenticationBloc>().add(AuthLogoutRequested()),
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
