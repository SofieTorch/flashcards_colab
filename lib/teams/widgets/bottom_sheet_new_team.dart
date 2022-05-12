import 'package:flashcards_colab/teams/teams.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomSheetNewTeam extends StatelessWidget {
  const BottomSheetNewTeam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: mediaQueryData.viewInsets,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Name:'),
            _TeamNameInput(),
            SizedBox(height: 8),
            Text('Description:'),
            _TeamDescriptionInput(),
            SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: _CreateTeamButtom(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamNameInput extends StatelessWidget {
  const _TeamNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (name) =>
          context.read<TeamListBloc>().add(NewTeamNameChanged(name)),
    );
  }
}

class _TeamDescriptionInput extends StatelessWidget {
  const _TeamDescriptionInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (description) => context
          .read<TeamListBloc>()
          .add(NewTeamDescriptionChanged(description)),
    );
  }
}

class _CreateTeamButtom extends StatelessWidget {
  const _CreateTeamButtom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamListBloc, TeamListState>(
      builder: (context, state) {
        return state.newTeamStatus == NewTeamStatus.inProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () =>
                    context.read<TeamListBloc>().add(const NewTeamCreated()),
                child: const Text('Create team'),
              );
      },
    );
  }
}
