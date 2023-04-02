import 'package:flutter/material.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/form/app_form.dart';
import 'package:myguide/ui/input/text.dart';

const _kEmail = 'email';
const _kPwd = 'password';
const _kRepeatPwd = 'repeat-password';

extension AuthFormValue on FormValue {
  String get email => this[_kEmail];

  String get pwd => this[_kPwd];

  String get repeatPwd => this[_kRepeatPwd];

  setEmail(String? e) => this[_kEmail] = e;

  setPwd(String? p) => this[_kPwd] = p;

  setRepeatPwd(String? p) => this[_kRepeatPwd] = p;
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    this.onSubmit,
  });

  final FormValueCallback? onSubmit;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final GlobalKey<AppFormState> formKey;
  late final FormValue value;

  @override
  void initState() {
    super.initState();
    value = {_kEmail: '', _kPwd: ''};
    formKey = GlobalKey();
  }

  void onSubmit() {
    if (formKey.currentState!.validate()) widget.onSubmit!(value);
  }

  @override
  Widget build(BuildContext context) {
    return AppForm(
      key: formKey,
      children: [
        AppEmailField(onChanged: value.setEmail),
        AppPasswordField(onChanged: value.setPwd),
        ElevatedButton(
          onPressed: widget.onSubmit == null ? null : onSubmit,
          child: const Text('Login'),
        ),
      ],
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({
    super.key,
    this.onSubmit,
  });

  final FormValueCallback? onSubmit;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  late final GlobalKey<AppFormState> formKey;
  late final FormValue value;

  @override
  void initState() {
    super.initState();
    value = {_kEmail: '', _kPwd: '', _kRepeatPwd: ''};
    formKey = GlobalKey();
  }

  String? validateRepeatPwd() {
    if (value.repeatPwd == value.pwd) return null;
    return AppLocalizations.of(context)!.repeatPasswordErrorDoesNotMatch;
  }

  void onSubmit() {
    if (formKey.currentState!.validate()) widget.onSubmit!(value);
  }

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return AppForm(
      key: formKey,
      children: [
        AppEmailField(onChanged: value.setEmail),
        AppPasswordField(
          onChanged: (p) {
            value.setPwd(p);
            validateRepeatPwd();
          },
        ),
        AppRepeatPasswordField(
          validator: (_) => validateRepeatPwd(),
          onChanged: value.setRepeatPwd,
        ),
        ElevatedButton(
          onPressed: widget.onSubmit == null ? null : onSubmit,
          child: Text(copy.signup),
        ),
      ],
    );
  }
}
