part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = User.empty,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(User user)
      : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];

  static Future<AuthenticationState> fromUserFuture(Future<User> future) async {
    final user = await future;
    return user.isNotEmpty
        ? AuthenticationState.authenticated(user)
        : const AuthenticationState.unauthenticated();
  }
}
