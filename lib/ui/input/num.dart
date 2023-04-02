import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myguide/ui/input/input.dart';
import 'package:myguide/ui/spacers.dart';
import 'package:myguide/ui/theme.dart';

class AppNumFormField extends FormField<num> {
  AppNumFormField({
    super.key,
    num? initialValue,
    String? Function(num)? validator,
    ValueChanged<num?>? onChanged,
    bool isInteger = false,
    required String hint,
    String? description,
  }) : super(
          initialValue: initialValue ?? 0,
          enabled: onChanged != null,
          validator: (value) {
            if (value!.isNegative) return 'Insert a correct value';
            return null;
          },
          builder: (rawState) {
            final state = rawState as _AppNumFormFieldState;
            final theme = Theme.of(state.context);
            final inputDecorTheme = theme.inputDecorationTheme;
            final fillColor = state.hasError
                ? theme.colorScheme.error.withOpacity(.1)
                : inputDecorTheme.fillColor;

            return Input(
              label: hint,
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
                maxLength: 8,
                inputFormatters: [
                  isInteger
                      ? FilteringTextInputFormatter.allow(RegExp(r'[1-9]\d*'))
                      : FilteringTextInputFormatter.allow(RegExp(r'[\d,.]*')),
                ],
                onChanged: (v) {
                  if (v.startsWith('0') && v.length > 1) {
                    state.didChange(-1);
                    onChanged?.call(-1);
                    return;
                  }
                  final value = v.replaceAll(',', '.');
                  if (value.contains(('.'))) {
                    if (value.split('.')[1].length > 2) {
                      state.didChange(-1);
                      onChanged?.call(-1);
                      return;
                    }
                  }
                  if (value.isEmpty) {
                    state.didChange(null);
                    onChanged?.call(null);
                    return;
                  }
                  final numValue =
                      isInteger ? int.tryParse(value) : double.tryParse(value);
                  if (numValue == null) {
                    state.didChange(-1);
                    onChanged?.call(-1);
                    return;
                  }
                  state.didChange(numValue);
                  onChanged?.call(numValue);
                },
              ),
            );
          },
        );

  @override
  FormFieldState<num> createState() => _AppNumFormFieldState();
}

class _AppNumFormFieldState extends FormFieldState<num> {
  late TextEditingController controller;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController.fromValue(
      TextEditingValue(text: widget.initialValue?.toString() ?? ''),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  AppNumFormField get widget => super.widget as AppNumFormField;
}
