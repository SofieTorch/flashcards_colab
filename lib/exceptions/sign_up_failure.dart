class SignUpFailure implements Exception {
  const SignUpFailure() : _message = 'An unknown exception occurred.';

  final String _message;

  /// The associated error message.
  String get message => _message;
}
