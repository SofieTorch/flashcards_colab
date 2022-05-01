import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards_colab/data/repositories/authentication_repository.dart';
import 'package:flashcards_colab/exceptions/exceptions.dart';
import 'package:flashcards_colab/sign_up/sign_up.dart';
import 'package:formz/formz.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const SignUpState()) {
    on<SignUpNameChanged>(_onNameChanged);
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpConfirmedPasswordChanged>(_onConfirmedPasswordChanged);
    on<SignUpSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onNameChanged(
    SignUpNameChanged event,
    Emitter<SignUpState> emit,
  ) {
    final name = Name.dirty(event.name);
    emit(
      state.copyWith(
        name: name,
        status: Formz.validate([
          name,
          state.email,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void _onEmailChanged(
    SignUpEmailChanged event,
    Emitter<SignUpState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([
          state.name,
          email,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void _onPasswordChanged(
    SignUpPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([
          state.name,
          state.email,
          password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void _onConfirmedPasswordChanged(
    SignUpConfirmedPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    final confirmedPassword = ConfirmedPassword.dirty(
      value: event.confirmedPassword,
      password: state.password.value,
    );
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        status: Formz.validate([
          state.name,
          state.email,
          state.password,
          confirmedPassword,
        ]),
      ),
    );
  }

  Future<void> _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    // try {
    await _authenticationRepository.signUp(
      email: state.email.value.trim(),
      password: state.password.value,
      name: state.name.value,
    );

    emit(state.copyWith(status: FormzStatus.submissionSuccess));
    // } on SignUpFailure catch (e) {
    //   emit(state.copyWith(
    //     error: e,
    //     status: FormzStatus.submissionFailure,
    //   ));
    // }
  }
}
