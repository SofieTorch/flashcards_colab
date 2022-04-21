import 'package:appwrite/appwrite.dart';
import 'package:flashcards_colab/app/app.dart';
import 'package:flashcards_colab/authentication/bloc/authentication_bloc.dart';
import 'package:flashcards_colab/data/repositories/authentication_repository.dart';
import 'package:flashcards_colab/l10n/l10n.dart';
import 'package:flashcards_colab/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Client appwriteClient = Client();
  late AuthenticationRepository authRepository;

  @override
  void initState() {
    appwriteClient
        .setEndpoint('http://192.168.43.117:8080/v1')
        .setProject('6258b5fa4c4df1f577d4');

    authRepository = AuthenticationRepository(appwriteClient: appwriteClient);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authRepository,
      child: BlocProvider<AuthenticationBloc>(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authRepository,
        )..add(AuthenticationRequested()),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final AppRouter _router = AppRouter();
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: _router.onGenerateRoute,
      initialRoute: AppRouter.splash,
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushNamedAndRemoveUntil<void>(
                  AppRouter.home,
                  (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushNamedAndRemoveUntil<void>(
                  AppRouter.signIn,
                  (route) => false,
                );
                break;
              // ignore: no_default_cases
              default:
                break;
            }
          },
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }
}
