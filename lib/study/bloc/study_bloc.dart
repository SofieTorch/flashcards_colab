import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'study_event.dart';
part 'study_state.dart';

class StudyBloc extends Bloc<StudyEvent, StudyState> {
  StudyBloc() : super(StudyState()) {
    on<StudyEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
