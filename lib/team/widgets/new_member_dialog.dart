import 'package:flashcards_colab/team/team.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('New member email:'),
          _NewMemberEmailInput(),
          _AddMemberButton()
        ],
      ),
    );
  }
}

class _NewMemberEmailInput extends StatelessWidget {
  const _NewMemberEmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (email) =>
          context.read<TeamBloc>().add(NewMemberEmailChanged(email)),
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
          onPressed: () {
            context.read<TeamBloc>().add(const NewMemberInvited());
          },
          child: const Text('Invite'),
        );
      },
    );
  }
}
