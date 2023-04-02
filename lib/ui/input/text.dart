import 'package:flutter/material.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/input/input.dart';
import 'package:myguide/ui/spacers.dart';
import 'package:myguide/ui/tappable.dart';
import 'package:myguide/ui/theme.dart';

class AppTextFormField extends FormField<String> {
  final bool _obscured;

  AppTextFormField({
    super.key,
    String? initialValue,
    String? Function(String?)? validator,
    ValueChanged<String?>? onChanged,
    required String hint,
    String? description,
    bool obscured = false,
    int? minLines,
    int? maxLines,
  })  : _obscured = obscured,
        super(
          initialValue: initialValue,
          enabled: onChanged != null,
          validator: validator,
          builder: (rawState) {
            final state = rawState as _AppTextFormFieldState;
            final theme = Theme.of(state.context);
            final copy = AppLocalizations.of(state.context)!;
            final inputDecorTheme = theme.inputDecorationTheme;
            final fillColor = state.hasError
                ? theme.colorScheme.error.withOpacity(.1)
                : inputDecorTheme.fillColor;

            return Input(
              label: hint,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: state.controller,
                      decoration: InputDecoration(
                        contentPadding: AppInsets.s,
                        helperText: description,
                        hintText: hint,
                        errorText: state.errorText,
                        fillColor: fillColor,
                        filled: fillColor != null,
                      ),
                      cursorColor: theme.primaryColor,
                      focusNode: state.focusNode,
                      style: theme.textTheme.bM,
                      minLines: minLines,
                      maxLines: maxLines ?? 1,
                      obscureText: state.obscured,
                      onChanged: (value) {
                        final v = value.isEmpty ? null : value;
                        state.didChange(v);
                        onChanged?.call(v);
                      },
                    ),
                  ),
                  if (obscured)
                    SizedBox(
                      height: 48,
                      child: Tappable(
                        onTap: state.showHideText,
                        child: Container(
                          padding: AppInsets.hl,
                          alignment: Alignment.center,
                          color: inputDecorTheme.suffixStyle!.backgroundColor,
                          child: Stack(
                            children: [
                              Visibility(
                                visible: !state.obscured,
                                maintainAnimation: true,
                                maintainState: true,
                                maintainSize: true,
                                maintainInteractivity: true,
                                child: Text(
                                  copy.hide,
                                  style: inputDecorTheme.suffixStyle!,
                                ),
                              ),
                              Visibility(
                                visible: state.obscured,
                                maintainAnimation: true,
                                maintainState: true,
                                maintainSize: true,
                                maintainInteractivity: true,
                                child: Text(
                                  copy.show,
                                  style: inputDecorTheme.suffixStyle!,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );

  @override
  FormFieldState<String> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends FormFieldState<String> {
  late bool obscured;
  late TextEditingController controller;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    obscured = widget._obscured;
    controller = TextEditingController.fromValue(
      TextEditingValue(text: widget.initialValue ?? ''),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  AppTextFormField get widget => super.widget as AppTextFormField;

  void showHideText() {
    obscured = !obscured;
    didChange(value);
  }
}

/// ----------------------------------------------------------------------------
///                             EXPLICIT FIELDS
/// ----------------------------------------------------------------------------

class AppEmailField extends StatelessWidget {
  const AppEmailField({
    super.key,
    this.onChanged,
    this.initialValue,
    this.required = true,
  });

  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final bool required;

  static const _regExpSrc =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return AppTextFormField(
      initialValue: initialValue,
      hint: copy.email,
      onChanged: onChanged,
      validator: (value) {
        if (value == null && required) return copy.required;
        final regExp = RegExp(_regExpSrc);
        if (regExp.hasMatch(value ?? '')) return null;
        return copy.invalidEmail;
      },
    );
  }
}

class AppPhoneField extends StatelessWidget {
  const AppPhoneField({
    super.key,
    this.onChanged,
    this.initialValue,
  });

  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return AppTextFormField(
      initialValue: initialValue,
      hint: copy.phoneNumber,
      onChanged: onChanged,
    );
  }
}

class AppPasswordField extends StatelessWidget {
  const AppPasswordField({
    super.key,
    this.onChanged,
    this.enabled,
  });

  final ValueChanged<String?>? onChanged;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return AppTextFormField(
      obscured: true,
      hint: copy.password,
      onChanged: onChanged,
      validator: (value) {
        if (value == null) return copy.required;
        final buffer = StringBuffer();
        if (value.contains(' ')) buffer.writeln(copy.passwordErrorWhitespaces);
        if (value.length < 6) buffer.writeln(copy.passwordError6Chars);
        if (buffer.isEmpty) return null;
        return buffer.toString();
      },
    );
  }
}

class AppRepeatPasswordField extends StatelessWidget {
  const AppRepeatPasswordField({
    super.key,
    this.validator,
    this.onChanged,
    this.enabled,
  });

  final ValueChanged<String?>? onChanged;
  final bool? enabled;
  final String? Function(String)? validator;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return AppTextFormField(
      obscured: true,
      hint: copy.password,
      onChanged: onChanged,
      validator: (value) {
        if (value == null) return copy.required;
        return validator?.call(value);
      },
    );
  }
}

class AppNameField extends StatelessWidget {
  const AppNameField({
    super.key,
    this.initialValue,
    this.onChanged,
    this.enabled,
    required this.hint,
  });

  final String hint;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final bool? enabled;

  static const _regExpSrc = r'[a-zA-Z0-9_]';

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return AppTextFormField(
      initialValue: initialValue,
      hint: hint,
      onChanged: onChanged,
      validator: (value) {
        if (value == null) return copy.required;
        final buffer = StringBuffer();
        if (value.length < 3) buffer.writeln(copy.passwordError6Chars);
        if (value.isEmpty) return buffer.toString();
        final startEndCharRegexp = RegExp(_regExpSrc);
        if (!value.startsWith(startEndCharRegexp)) {
          buffer.write(copy.nameInvalidStart);
        }
        if (value.length > 1 &&
            !startEndCharRegexp.hasMatch(value.characters.last)) {
          buffer.write(copy.nameInvalidEnd);
        }
        if (buffer.isEmpty) return null;
        return buffer.toString();
      },
    );
  }
}

class AppMaterialField extends StatelessWidget {
  const AppMaterialField({
    super.key,
    this.initialValue,
    this.onChanged,
    this.enabled,
  });

  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return AppTextFormField(
      initialValue: initialValue,
      hint: copy.material,
      onChanged: onChanged,
    );
  }
}

class AppAddressField extends StatelessWidget {
  const AppAddressField({
    super.key,
    this.initialValue,
    this.onChanged,
  });

  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return AppTextFormField(
      initialValue: initialValue,
      hint: copy.address,
      onChanged: onChanged,
    );
  }
}

class AppCreationPlaceField extends StatelessWidget {
  const AppCreationPlaceField({
    super.key,
    this.initialValue,
    this.onChanged,
  });

  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return AppTextFormField(
      initialValue: initialValue,
      hint: copy.creationPlace,
      onChanged: onChanged,
    );
  }
}

class AppCreationYearField extends StatelessWidget {
  const AppCreationYearField({
    super.key,
    this.initialValue,
    this.onChanged,
  });

  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return AppTextFormField(
      initialValue: initialValue,
      hint: copy.creationYear,
      onChanged: onChanged,
    );
  }
}

class AppURLField extends StatelessWidget {
  const AppURLField({
    super.key,
    required this.hint,
    this.initialValue,
    this.onChanged,
    this.required = false,
  });

  final String hint;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final bool required;

  static const _regExpSrc =
      r'^[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)$';

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return AppTextFormField(
      initialValue: initialValue,
      hint: hint,
      validator: (value) {
        if (value == null) return required ? copy.required : null;
        final regExp = RegExp(_regExpSrc);
        if (regExp.hasMatch(value)) return null;
        return copy.websiteErrorNotValid;
      },
      onChanged: onChanged,
    );
  }
}

class AppDescriptionField extends StatelessWidget {
  const AppDescriptionField({
    super.key,
    this.onChanged,
    this.initialValue,
    this.validator,
  });

  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return AppTextFormField(
      initialValue: initialValue,
      hint: copy.description,
      validator: validator,
      onChanged: onChanged,
      minLines: 5,
      maxLines: 10,
    );
  }
}
