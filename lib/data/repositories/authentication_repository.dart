import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:flashcards_colab/exceptions/exceptions.dart';
import 'package:flashcards_colab/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  AuthenticationRepository({
    required this.appwriteClient,
  })  : appwriteAccount = Account(appwriteClient),
        prefs = SharedPreferences.getInstance();

  final Client appwriteClient;
  final FutureOr<SharedPreferences> prefs;
  final Account appwriteAccount;
  final _controller = StreamController<AuthenticationStatus>();
  final _userCollectionId = '6274b373afa07eaee9c0';

  Stream<AuthenticationStatus> get status async* {
    yield* _controller.stream;
  }

  Future<User> get currentUser async {
    try {
      final appwriteUser = await appwriteAccount.get();
      return appwriteUser.toUser;
    } catch (e) {
      return User.empty;
    }
  }

  Future<User> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final appwriteUser = await appwriteAccount.create(
        userId: 'unique()',
        email: email,
        password: password,
        name: name,
      );

      await signIn(email: email, password: password);
      final database = Database(appwriteClient);

      await database.createDocument(
        collectionId: _userCollectionId,
        documentId: appwriteUser.$id,
        write: <String>['user:${appwriteUser.$id}'],
        read: <String>['user:${appwriteUser.$id}'],
        data: <String, dynamic>{
          'name': appwriteUser.name,
          'email': appwriteUser.email,
        },
      );

      return appwriteUser.toUser;
    } on AppwriteException catch (e) {
      throw SignUpFailure.fromType(e.type!);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final session = await appwriteAccount.createSession(
        email: email,
        password: password,
      );
      await (await prefs).setString('sessionId', session.$id);
      _controller.add(AuthenticationStatus.authenticated);
    } on AppwriteException catch (e) {
      throw SignInFailure.fromCode(e.code!);
    } catch (e) {
      throw const SignInFailure();
    }
  }

  Future<void> signInWithGoogle() async {
    await appwriteAccount.createOAuth2Session(
      provider: 'google',
    );
  }

  Future<void> logOut() async {
    final sessionId = (await prefs).getString('sessionId');
    try {
      await appwriteAccount.deleteSession(sessionId: sessionId!);
    } catch (e) {
      await appwriteAccount.deleteSessions();
    }

    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}

extension on appwrite_models.User {
  User get toUser {
    return User(id: $id, email: email, name: name);
  }
}
