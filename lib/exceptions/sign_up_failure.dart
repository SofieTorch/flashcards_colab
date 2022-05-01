class SignUpFailure implements Exception {
  const SignUpFailure() : _message = 'An unknown exception occurred.';

  /// Create an authentication error message
  /// from an http response code.
  factory SignUpFailure.fromType(String type) {
    switch (type) {
      case 'user_already_exists':
        return AccountAlreadyExistsFailure();
      default:
        return const SignUpFailure();
    }
  }

  final String _message;

  /// The associated error message.
  String get message => _message;
}

/// Thrown when the user trying to authenticate
/// entered an incorrect password or email.
class AccountAlreadyExistsFailure extends SignUpFailure {
  @override
  String get message => 'Account already exists.';
}
