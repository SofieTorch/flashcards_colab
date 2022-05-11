part of 'study_bloc.dart';

abstract class StudyEvent extends Equatable {
  const StudyEvent();

  @override
  List<Object> get props => [];
}

class TodayFlashcardsRequested extends StudyEvent {}

class FlashcardAnswered extends StudyEvent {
  const FlashcardAnswered(this.weight);
  final int weight;
}

class ShowAnswerRequested extends StudyEvent {}
