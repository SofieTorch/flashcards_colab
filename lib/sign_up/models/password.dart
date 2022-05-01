import 'package:formz/formz.dart';

enum PasswordValidationError { empty, lessThanEight }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String? value) {
    PasswordValidationError? error;

    value != null && value.length >= 8
        ? error = error
        : error = PasswordValidationError.lessThanEight;

    value?.isNotEmpty == true
        ? error = error
        : error = PasswordValidationError.empty;

    return error;
  }
}
