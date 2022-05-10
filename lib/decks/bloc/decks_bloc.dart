import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards_colab/data/repositories/decks_repository.dart';
import 'package:flashcards_colab/models/models.dart';

part 'decks_event.dart';
part 'decks_state.dart';

class DecksBloc extends Bloc<DecksEvent, DecksState> {
  DecksBloc({
    required DecksRepository decksRepository,
    this.teamId,
  })  : _decksRepository = decksRepository,
        super(const DecksState()) {
    on<DecksRequested>(_onDecksRequested);
    on<NewDeckTitleChanged>(_onNewDeckTitleChanged);
    on<NewDeckCreated>(_onNewDeckCreated);
    on<SubscriptionRequested>(_onSubscriptionRequested);
    on<DeckListChanged>(_onDeckListChanged);
  }

  final DecksRepository _decksRepository;
  StreamSubscription<Deck>? _deckStreamSubscription;
  String? teamId;

  @override
  Future<void> close() {
    _deckStreamSubscription?.cancel();
    _decksRepository.dispose();
    return super.close();
  }

  Future<void> _onDecksRequested(
    DecksRequested event,
    Emitter<DecksState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == DecksStatus.initial) {
        final decks = await _decksRepository.getDecks(teamId: teamId);
        return emit(
          state.copyWith(
            status: DecksStatus.success,
            decks: decks,
            hasReachedMax: false,
          ),
        );
      }

      final decks = await _decksRepository.getDecks(
        teamId: teamId,
        offset: state.decks.length,
      );

      decks.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: DecksStatus.success,
                decks: decks,
                hasReachedMax: false,
              ),
            );
    } catch (e) {
      emit(state.copyWith(status: DecksStatus.failure));
    }
  }

  void _onNewDeckTitleChanged(
    NewDeckTitleChanged event,
    Emitter<DecksState> emit,
  ) {
    emit(
      state.copyWith(
        newDeck: state.newDeck.copyWith(title: event.title),
      ),
    );
  }

  Future<void> _onNewDeckCreated(
    NewDeckCreated event,
    Emitter<DecksState> emit,
  ) async {
    try {
      emit(state.copyWith(newDeckStatus: NewDeckStatus.inProgress));

      await _decksRepository.createDeck(
        title: state.newDeck.title,
        teamId: teamId,
      );

      if (teamId != null) {
        emit(
          state.copyWith(
            newDeckStatus: NewDeckStatus.success,
            status: DecksStatus.initial,
          ),
        );
        add(DecksRequested());
      } else {
        emit(
          state.copyWith(newDeckStatus: NewDeckStatus.success),
        );
      }
    } catch (e) {
      emit(state.copyWith(newDeckStatus: NewDeckStatus.failure));
    }
  }

  void _onSubscriptionRequested(
    SubscriptionRequested event,
    Emitter<DecksState> emit,
  ) {
    _decksRepository.subscribeToTeamDecks(teamId: teamId!);
    _deckStreamSubscription = _decksRepository.decksStream.listen((event) {
      add(DeckListChanged(event));
    });
  }

  void _onDeckListChanged(
    DeckListChanged event,
    Emitter<DecksState> emit,
  ) {
    final deck = state.decks.firstWhere(
      (element) => element.id == event.deck.id,
      orElse: () => Deck.empty,
    );

    if (deck.isEmpty) {
      emit(state.copyWith(decks: state.decks..add(deck)));
    } else {
      final decksCopy = List<Deck>.from(state.decks);
      decksCopy[decksCopy.indexOf(deck)] = event.deck;
      emit(state.copyWith(decks: decksCopy));
    }
  }
}
