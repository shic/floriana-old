import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myguide/core/features/authentication/all.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/pages/utils/provider.dart';
import 'package:myguide/ui/dialog.dart';
import 'package:myguide/ui/form/app_form.dart';
import 'package:myguide/ui/form/auth_form.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/spacers.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({
    super.key,
    this.onComplete,
  });

  final VoidCallback? onComplete;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

enum _AuthType { login, signup }

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  late final ValueNotifier<_AuthType> authTypeN;

  @override
  void initState() {
    super.initState();
    authTypeN = ValueNotifier(_AuthType.login);
  }

  @override
  void dispose() {
    authTypeN.dispose();
    super.dispose();
  }

  Future<void> onSignupSubmit(FormValue value) async {
    final authController = context.read(authProvider.notifier);
    return context.guardThrowable(
      operation: () async {
        await authController.signUp(email: value.email, pwd: value.pwd);
        widget.onComplete?.call();
      },
    );
  }

  Future<void> onLoginSubmit(FormValue value) {
    final authController = context.read(authProvider.notifier);
    return context.guardThrowable(
      operation: () async {
        await authController.signIn(email: value.email, pwd: value.pwd);
        widget.onComplete?.call();
      },
    );
  }

  void _changeType() {
    switch (authTypeN.value) {
      case _AuthType.login:
        authTypeN.value = _AuthType.signup;
        break;
      case _AuthType.signup:
        authTypeN.value = _AuthType.login;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: AppInsets.page +
          defaultTargetPlatform.when(
            context: context,
            mobile: EdgeInsets.zero,
            desktop: AppInsets.hpage +
                EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * .2,
                ),
          ),
      child: ValueListenableBuilder<_AuthType>(
        valueListenable: authTypeN,
        builder: (_, authType, __) {
          final Widget child;
          switch (authType) {
            case _AuthType.login:
              child = Column(
                children: [
                  LoginForm(onSubmit: onLoginSubmit),
                  const AppSpacer.s(),
                  Text(copy.dontHaveAnAccount),
                  TextButton(
                    onPressed: _changeType,
                    child: Text(copy.signup),
                  ),
                ],
              );
              break;
            case _AuthType.signup:
              child = Column(
                children: [
                  SignupForm(onSubmit: onSignupSubmit),
                  Text(copy.alreadyHaveAnAccount),
                  TextButton(
                    onPressed: _changeType,
                    child: Text(copy.login),
                  ),
                ],
              );
              break;
          }
          return child;
        },
      ),
    );
  }
}
