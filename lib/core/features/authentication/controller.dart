import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/services/auth_service.dart';
import 'package:myguide/core/utils/async.dart';

final uidProvider = Provider((ref) {
  return ref.watch(authProvider.select((a) => a.uid));
});

final authProvider = StateNotifierProvider<AuthController, Auth>((ref) {
  final authService = AuthService.shared;
  final auth = authService.currentAuth;
  return AuthController(authService: authService, initValue: auth);
});

class AuthController extends StateNotifier<Auth>
    with StateNotifierSubscriptionMixin {
  final AuthService authService;

  AuthController({
    required this.authService,
    required Auth initValue,
  }) : super(initValue) {
    subscriptions = authService.auth$.listen((auth) => state = auth);
  }

  Future<void> signIn({required String email, required String pwd}) async {
    await AuthService.shared.signInWithEmailAndPassword(
      email: email,
      password: pwd,
    );
  }

  Future<void> signUp({required String email, required String pwd}) async {
    await AuthService.shared.signUpWithEmailAndPassword(
      email: email,
      password: pwd,
    );
  }

  Future<void> signOut() async {
    await AuthService.shared.signOut();
  }
}
