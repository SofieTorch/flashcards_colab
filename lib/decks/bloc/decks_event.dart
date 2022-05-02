part of 'decks_bloc.dart';

abstract class DecksEvent extends Equatable {
  const DecksEvent();

  @override
  List<Object> get props => [];
}

class DecksRequested extends DecksEvent {}

class NewDeckTitleChanged extends DecksEvent {
  const NewDeckTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

class NewDeckCreated extends DecksEvent {
  const NewDeckCreated();
}
