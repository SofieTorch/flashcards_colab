part of 'sign_in_bloc.dart';

class SignInState extends Equatable {
  const SignInState({
    this.status = FormzStatus.pure,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.error,
  });

  final FormzStatus status;
  final Email email;
  final Password password;
  final SignInFailure? error;

  SignInState copyWith({
    FormzStatus? status,
    Email? email,
    Password? password,
    SignInFailure? error,
  }) {
    return SignInState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      error: error,
    );
  }

  @override
  List<Object> get props => [status, email, password];
}
