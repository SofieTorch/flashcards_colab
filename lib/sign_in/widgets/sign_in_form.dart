import 'package:flashcards_colab/app/app.dart';
import 'package:flashcards_colab/exceptions/exceptions.dart';
import 'package:flashcards_colab/l10n/l10n.dart';
import 'package:flashcards_colab/sign_in/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  _getErrorMessage(state.error!, l10n),
                ),
              ),
            );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.signInEmailLabel),
          _EmailInput(),
          const Padding(padding: EdgeInsets.all(6)),
          Text(l10n.signInPasswordLabel),
          _PasswordInput(),
          const Padding(padding: EdgeInsets.all(12)),
          _LoginButton(),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pushNamed(
                context,
                AppRouter.signUp,
              ),
              child: Text(l10n.signInToSignUpButtonText),
            ),
          )
        ],
      ),
    );
  }

  String _getErrorMessage(SignInFailure failure, AppLocalizations l10n) {
    if (failure is InvalidCredentialsFailure) {
      return l10n.authInvalidCredentialsFailure;
    } else {
      return l10n.authUnexpectedFailure;
    }
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (email) =>
              context.read<SignInBloc>().add(SignInEmailChanged(email)),
          decoration: InputDecoration(
            errorText:
                state.email.invalid ? l10n.signInEmailInvalidMessage : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (password) =>
              context.read<SignInBloc>().add(SignInPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            errorText: state.password.invalid
                ? _getValidationMessage(state.password.error, l10n)
                : null,
          ),
        );
      },
    );
  }

  String? _getValidationMessage(
    PasswordValidationError? error,
    AppLocalizations l10n,
  ) {
    if (error == PasswordValidationError.empty) {
      return l10n.signInPasswordEmptyMessage;
    }
    if (error == PasswordValidationError.lessThanEight) {
      return l10n.signInPasswordLengthMessage;
    }
    return null;
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.status.isValidated
                      ? () {
                          context
                              .read<SignInBloc>()
                              .add(const SignInSubmitted());
                        }
                      : null,
                  child: Text(l10n.signInButtonText),
                ),
              );
      },
    );
  }
}
