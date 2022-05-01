import 'package:flashcards_colab/l10n/l10n.dart';
import 'package:flashcards_colab/theme/theme.dart';
import 'package:flutter/material.dart';

class SignInHeader extends StatelessWidget {
  const SignInHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Text(
          l10n.signInWelcomeHeader,
          style: Theme.of(context)
              .textTheme
              .headline1
              ?.copyWith(color: AppColors.mirage),
        ),
        Text(
          l10n.signInMessageHeader,
          style: Theme.of(context)
              .textTheme
              .subtitle1
              ?.copyWith(color: AppColors.mirage),
        ),
      ],
    );
  }
}
