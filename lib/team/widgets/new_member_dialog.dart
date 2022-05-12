import 'package:flashcards_colab/l10n/l10n.dart';
import 'package:flashcards_colab/team/team.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class NewMemberDialog extends StatelessWidget {
  const NewMemberDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('New member email:'),
          SizedBox(height: 4),
          _NewMemberEmailInput(),
          SizedBox(height: 12),
          Align(
            alignment: Alignment.bottomRight,
            child: _AddMemberButton(),
          ),
        ],
      ),
    );
  }
}

class _NewMemberEmailInput extends StatelessWidget {
  const _NewMemberEmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<TeamBloc, TeamState>(
      builder: (context, state) {
        return TextField(
          onChanged: (email) =>
              context.read<TeamBloc>().add(NewMemberEmailChanged(email)),
          decoration: InputDecoration(
            errorText: state.newMemberEmail.invalid
                ? l10n.signInEmailInvalidMessage
                : null,
          ),
        );
      },
    );
  }
}

class _AddMemberButton extends StatelessWidget {
  const _AddMemberButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamBloc, TeamState>(
      builder: (context, state) {
        if (state.newMemberStatus == NewMemberStatus.inProgress) {
          return const CircularProgressIndicator();
        }

        return ElevatedButton(
          onPressed: state.status.isValidated
              ? () {
                  context.read<TeamBloc>().add(const NewMemberInvited());
                }
              : null,
          child: const Text('Invite'),
        );
      },
    );
  }
}
