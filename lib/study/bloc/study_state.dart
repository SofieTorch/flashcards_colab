part of 'study_bloc.dart';

enum TodayFlashcardsState { initial, loading, failure, success }
enum UpdateRecallState { initial, inProgress, failure, success }

class StudyState extends Equatable {
  const StudyState();

  // final TodayFlashcardsState todayFlashcardsState;

  @override
  List<Object> get props => [];
}
