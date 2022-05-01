import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationError { empty, mismatch }

class ConfirmedPassword
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  const ConfirmedPassword.pure()
      : _password = '',
        super.pure('');
  const ConfirmedPassword.dirty({
    String value = '',
    required String password,
  })  : _password = password,
        super.dirty(value);

  final String _password;

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    ConfirmedPasswordValidationError? error;

    value.isNotEmpty == true
        ? error = error
        : error = ConfirmedPasswordValidationError.empty;

    value == _password
        ? error = error
        : error = ConfirmedPasswordValidationError.mismatch;

    return error;
  }
}
