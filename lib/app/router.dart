import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flashcards_colab/app/app.dart';
import 'package:flashcards_colab/connectivity/connectivity.dart';
import 'package:flashcards_colab/join_team/join_team.dart';
import 'package:flashcards_colab/models/models.dart';
import 'package:flashcards_colab/profile/profile.dart';
import 'package:flashcards_colab/sign_in/sign_in.dart';
import 'package:flashcards_colab/sign_up/sign_up.dart';
import 'package:flashcards_colab/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  final ConnectivityBloc connectivityBloc = ConnectivityBloc(Connectivity());

  static const String home = '/';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String splash = '/splash';
  static const String profile = '/profile';
  static const String join = 'join';

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
      case profile:
        return MaterialPageRoute<Widget>(
          builder: (_) {
            return BlocProvider<ConnectivityBloc>.value(
              value: connectivityBloc..add(const ConnectivityRequested()),
              child: const ConnectivityListener(child: ProfilePage()),
            );
          },
        );
      case splash:
        return MaterialPageRoute<Widget>(
          builder: (_) {
            return BlocProvider<ConnectivityBloc>.value(
              value: connectivityBloc..add(const ConnectivityRequested()),
              child: const ConnectivityListener(child: SplashPage()),
            );
          },
        );
      case home:
        return MaterialPageRoute<Widget>(
          builder: (_) {
            return BlocProvider<ConnectivityBloc>.value(
              value: connectivityBloc..add(const ConnectivityRequested()),
              child: const ConnectivityListener(child: RootPage()),
            );
          },
        );
      default:
        return _parseUrl(routeSettings.name!) ??
            MaterialPageRoute<Widget>(
              builder: (_) {
                return BlocProvider<ConnectivityBloc>.value(
                  value: connectivityBloc..add(const ConnectivityRequested()),
                  child: const ConnectivityListener(child: SplashPage()),
                );
              },
            );
        ;
    }
  }

  MaterialPageRoute? _parseUrl(String url) {
    final uri = Uri.parse(url);
    if (uri.pathSegments.first == join) {
      final membership = Membership(
        teamId: uri.queryParameters['teamId']!,
        membershipId: uri.queryParameters['membershipId']!,
        userId: uri.queryParameters['userId']!,
        secret: uri.queryParameters['secret']!,
      );

      return MaterialPageRoute<Widget>(
        builder: (_) {
          return BlocProvider<ConnectivityBloc>.value(
            value: connectivityBloc..add(const ConnectivityRequested()),
            child: ConnectivityListener(child: JoinTeamPage(membership)),
          );
        },
      );
    }

    return null;
  }

  void dispose() {
    connectivityBloc.close();
  }
}
