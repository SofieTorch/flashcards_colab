import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards_colab/data/repositories/authentication_repository.dart';
import 'package:flashcards_colab/models/models.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationRequested>(_onAuthenticationRequested);
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthLogoutRequested>(_onAuthenticationLogoutRequested);
    on<VerifyAuthRequested>(_onVerifyAuthenticationRequested);
  }

  final AuthenticationRepository _authRepository;
  late StreamSubscription<AuthenticationStatus> _authStatusSubscription;

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    _authRepository.dispose();
    return super.close();
  }

  Future<void> _onAuthenticationRequested(
    AuthenticationRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    add(VerifyAuthRequested());
    _authStatusSubscription = _authRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  Future<void> _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        final user = await _authRepository.currentUser;
        return emit(
          user.isNotEmpty
              ? AuthenticationState.authenticated(user)
              : const AuthenticationState.unauthenticated(),
        );
      case AuthenticationStatus.unknown:
        return emit(const AuthenticationState.unknown());
    }
  }

  void _onAuthenticationLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _authRepository.logOut();
  }

  Future<void> _onVerifyAuthenticationRequested(
    VerifyAuthRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    final user = await _authRepository.currentUser;
    emit(
      user.isNotEmpty
          ? AuthenticationState.authenticated(user)
          : const AuthenticationState.unauthenticated(),
    );
  }
}
