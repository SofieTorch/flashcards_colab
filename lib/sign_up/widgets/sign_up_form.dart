import 'package:flashcards_colab/app/app.dart';
import 'package:flashcards_colab/exceptions/exceptions.dart';
import 'package:flashcards_colab/l10n/l10n.dart';
import 'package:flashcards_colab/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  _getErrorMessage(state.error, l10n),
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
          _NameInput(),
          Text(l10n.signInEmailLabel),
          _EmailInput(),
          const Padding(padding: EdgeInsets.all(6)),
          Text(l10n.signInPasswordLabel),
          _PasswordInput(),
          Text(l10n.signInPasswordLabel),
          _ConfirmedPasswordInput(),
          const Padding(padding: EdgeInsets.all(12)),
          _LoginButton(),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pushNamed(
                context,
                AppRouter.signIn,
              ),
              child: Text(l10n.signInToSignUpButtonText),
            ),
          )
        ],
      ),
    );
  }

  String _getErrorMessage(SignUpFailure? failure, AppLocalizations l10n) {
    return l10n.authUnexpectedFailure;
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<SignUpBloc>().add(SignUpNameChanged(email)),
          decoration: InputDecoration(
            errorText:
                state.email.invalid ? l10n.signInEmailInvalidMessage : null,
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<SignUpBloc>().add(SignUpEmailChanged(email)),
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
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SignUpBloc>().add(SignUpPasswordChanged(password)),
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

class _ConfirmedPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) => context
              .read<SignUpBloc>()
              .add(SignUpConfirmedPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            errorText: state.password.invalid
                ? _getValidationMessage(state.confirmedPassword.error, l10n)
                : null,
          ),
        );
      },
    );
  }

  String? _getValidationMessage(
    ConfirmedPasswordValidationError? error,
    AppLocalizations l10n,
  ) {
    if (error == ConfirmedPasswordValidationError.empty) {
      return l10n.signInPasswordEmptyMessage;
    }
    if (error == ConfirmedPasswordValidationError.mismatch) {
      return l10n.signInPasswordLengthMessage;
    }
    return null;
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  onPressed: state.status.isValidated
                      ? () {
                          context
                              .read<SignUpBloc>()
                              .add(const SignUpSubmitted());
                        }
                      : null,
                  child: Text(l10n.signInButtonText),
                ),
              );
      },
    );
  }
}
