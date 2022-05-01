/// Thrown during the log in/sign in process if a failure occurs.
class SignInFailure implements Exception {
  const SignInFailure() : _message = 'An unknown exception occurred.';

  /// Create an authentication error message
  /// from an http response code.
  factory SignInFailure.fromCode(int code) {
    switch (code) {
      case 401:
        return InvalidCredentialsFailure();
      default:
        return const SignInFailure();
    }
  }

  final String _message;

  /// The associated error message.
  String get message => _message;
}

/// Thrown when the user trying to authenticate
/// entered an incorrect password or email.
class InvalidCredentialsFailure extends SignInFailure {
  @override
  String get message => 'Incorrect user or password.';
}
