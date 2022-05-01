import 'package:formz/formz.dart';

enum NameValidationError { empty }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidationError? validator(String? value) {
    NameValidationError? error;

    value?.trim().isNotEmpty == true
        ? error = error
        : error = NameValidationError.empty;

    return error;
  }
}
