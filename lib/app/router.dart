import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flashcards_colab/app/app.dart';
import 'package:flashcards_colab/connectivity/connectivity.dart';
import 'package:flashcards_colab/sign_in/sign_in.dart';
import 'package:flashcards_colab/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  final ConnectivityBloc connectivityBloc = ConnectivityBloc(Connectivity());

  static const String home = '/';
  static const String signIn = '/signin';
  static const String signUp = '/signup';

  /// Maps a given route to its corresponding page, initializing
  /// the necessary bloc providers for the page.
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case signUp:
        return MaterialPageRoute<Widget>(
          builder: (_) {
            return BlocProvider<ConnectivityBloc>.value(
              value: connectivityBloc..add(const ConnectivityRequested()),
              child: const ConnectivityListener(child: SignUpPage()),
            );
          },
        );
      case signIn:
        return MaterialPageRoute<Widget>(
          builder: (_) {
            return BlocProvider<ConnectivityBloc>.value(
              value: connectivityBloc..add(const ConnectivityRequested()),
              child: const ConnectivityListener(child: SignInPage()),
            );
          },
        );
      case home:
      default:
        return MaterialPageRoute<Widget>(
          builder: (_) {
            return BlocProvider<ConnectivityBloc>.value(
              value: connectivityBloc..add(const ConnectivityRequested()),
              child: const ConnectivityListener(child: RootPage()),
            );
          },
        );
    }
  }

  void dispose() {
    connectivityBloc.close();
  }
}
