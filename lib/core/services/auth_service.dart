import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:myguide/core/utils/initializable.dart';

enum AuthRole {
  anonymous,
  user,
  manager;

  static Iterable<AuthRole> fromToken(IdTokenResult token) {
    final claims = token.claims;
    final roles = <AuthRole>[
      if (claims?['user'] == true) AuthRole.user,
      if (claims?['manager'] == true) AuthRole.manager,
    ];
    return roles;
  }
}

class Auth extends Equatable {
  final String uid;
  final bool isAnonymous;
  final Iterable<AuthRole> roles;

  const Auth.anonymous({
    required this.uid,
  })  : isAnonymous = true,
        roles = const [];

  const Auth.identified({
    required this.uid,
    required this.roles,
  }) : isAnonymous = false;

  bool hasRole(AuthRole role) {
    return roles.contains(role);
  }

  static FutureOr<Auth> fromUser(User user) async {
    if (user.isAnonymous) return Auth.anonymous(uid: user.uid);
    final idToken = await user.getIdTokenResult();
    return Auth.identified(uid: user.uid, roles: AuthRole.fromToken(idToken));
  }

  @override
  List<Object?> get props => [uid, roles];
}

enum AuthError { userNotFound, unknown, userAlreadyExists, wrongPassword }

class AuthService with Awaitable<Auth> {
  static AuthService? _authService;

  static AuthService get shared => _authService ??= AuthService();

  final FirebaseAuth _firebaseAuth;

  Stream<Auth> get auth$ => _firebaseAuth.userChanges().asyncMap(_parseUser);

  late Auth currentAuth;

  AuthService() : _firebaseAuth = FirebaseAuth.instance {
    _initialize();
  }

  Future<void> _initialize() async {
    auth$.listen((auth) {
      if (!isInitialized) initializeWithValue(auth);
      currentAuth = auth;
    });
  }

  Future<Auth> _parseUser(User? user) async {
    final User parsedUser;
    if (user == null) {
      final credential = await _firebaseAuth.signInAnonymously();
      parsedUser = credential.user!;
    } else {
      parsedUser = user;
    }
    return await Auth.fromUser(parsedUser);
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } catch (error) {
      throw _parseError(error);
    }
  }

  Future<Auth> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final uCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Auth.fromUser(uCredential.user!);
    } catch (error) {
      throw _parseError(error);
    }
  }

  Future<Auth> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      final uCredential = await _firebaseAuth.signInWithCredential(credential);
      await Future.delayed(const Duration(milliseconds: 200));
      return Auth.fromUser(uCredential.user!);
    } catch (error) {
      throw _parseError(error);
    }
  }

  AuthError _parseError(dynamic error) {
    if (error is FirebaseAuthException) {
      debugPrint(error.code);
      switch (error.code) {
        case 'user-not-found': return AuthError.userNotFound;
        case 'wrong-password': return AuthError.wrongPassword;
        case 'email-already-in-use': return AuthError.userAlreadyExists;
      }
    }
    return AuthError.unknown;
  }
}
