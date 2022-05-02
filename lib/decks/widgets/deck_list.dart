import 'package:flashcards_colab/decks/decks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeckList extends StatefulWidget {
  const DeckList({Key? key}) : super(key: key);

  @override
  State<DeckList> createState() => _DeckListState();
}

class _DeckListState extends State<DeckList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DecksBloc, DecksState>(
      builder: (context, state) {
        switch (state.status) {
          case DecksStatus.failure:
            return const Center(child: Text('Failed to fetch decks'));
          case DecksStatus.success:
            if (state.decks.isEmpty) {
              return const Center(child: Text('Without decks yet'));
            }
            return ListView.builder(
              itemCount: state.decks.length,
              itemBuilder: (_, index) {
                return DeckListItem(state.decks[index]);
              },
            );
          // ignore: no_default_cases
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<DecksBloc>().add(DecksRequested());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
