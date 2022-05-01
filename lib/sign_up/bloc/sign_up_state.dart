part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.status = FormzStatus.pure,
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.error,
  });

  final FormzStatus status;
  final Name name;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final SignUpFailure? error;

  SignUpState copyWith({
    FormzStatus? status,
    Name? name,
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    SignUpFailure? error,
  }) {
    return SignUpState(
      status: status ?? this.status,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      error: error,
    );
  }

  @override
  List<Object> get props => [status, name, email, password, confirmedPassword];
}
