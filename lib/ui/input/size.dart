import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myguide/core/features/artwork_management/domain.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/input/input.dart';
import 'package:myguide/ui/spacers.dart';
import 'package:myguide/ui/theme.dart';

class AppSizeFormField extends FormField<ArtworkSize> {
  AppSizeFormField({
    super.key,
    ArtworkSize? initialValue,
    String? Function(ArtworkSize)? validator,
    ValueChanged<ArtworkSize>? onChanged,
    String? description,
  }) : super(
          initialValue: initialValue ?? const ArtworkSize(),
          enabled: onChanged != null,
          validator: validator == null ? null : (value) => validator(value!),
          builder: (rawState) {
            final state = rawState as _AppSizeFormFieldState;
            final copy = AppLocalizations.of(state.context)!;
            final theme = Theme.of(state.context);
            final inputDecorTheme = theme.inputDecorationTheme;
            final fillColor = state.hasError
                ? theme.colorScheme.error.withOpacity(.1)
                : inputDecorTheme.fillColor;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(copy.sizeInCentimeters, style: inputDecorTheme.labelStyle),
                const AppSpacer.xs(),
                Row(
                  children: [
                    state.buildSizeTextField(
                      controller: state.wController,
                      fillColor: fillColor,
                      hint: copy.width,
                      onChanged: onChanged,
                    ),
                    const AppSpacer.m(),
                    state.buildSizeTextField(
                      controller: state.hController,
                      fillColor: fillColor,
                      hint: copy.height,
                      onChanged: onChanged,
                    ),
                    const AppSpacer.m(),
                    state.buildSizeTextField(
                      controller: state.dController,
                      fillColor: fillColor,
                      hint: copy.depth,
                      onChanged: onChanged,
                    ),
                  ],
                ),
              ],
            );
          },
        );

  @override
  FormFieldState<ArtworkSize> createState() => _AppSizeFormFieldState();
}

class _AppSizeFormFieldState extends FormFieldState<ArtworkSize> {
  late TextEditingController wController;
  late TextEditingController hController;
  late TextEditingController dController;

  String _computeInitValue(double? initValue) {
    return initValue?.toString() ?? '';
  }

  @override
  void initState() {
    super.initState();
    final initValue = widget.initialValue!;
    wController = TextEditingController.fromValue(
      TextEditingValue(text: _computeInitValue(initValue.width)),
    );
    hController = TextEditingController.fromValue(
      TextEditingValue(text: _computeInitValue(initValue.height)),
    );
    dController = TextEditingController.fromValue(
      TextEditingValue(text: _computeInitValue(initValue.depth)),
    );
  }

  Widget buildSizeTextField({
    required TextEditingController controller,
    required Color? fillColor,
    required String hint,
    void Function(ArtworkSize)? onChanged,
  }) {
    void Function(String)? listener;
    if (onChanged != null) {
      listener = (v) {
        final doubleValue = double.tryParse(v);
        final ArtworkSize newValue;
        if (controller == wController) {
          newValue = ArtworkSize(
            width: doubleValue,
            height: value!.height,
            depth: value!.depth,
          );
        } else if (controller == hController) {
          newValue = ArtworkSize(
            width: value!.width,
            height: doubleValue,
            depth: value!.depth,
          );
        } else {
          newValue = ArtworkSize(
            width: value!.width,
            height: value!.height,
            depth: doubleValue,
          );
        }
        didChange(newValue);
        onChanged.call(newValue);
      };
    }

    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 75,
        maxWidth: 100,
      ),
      child: Input(
        label: hint,
        child: TextField(
          controller: controller,
          enabled: listener != null,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: theme.textTheme.bM,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
            TextInputFormatter.withFunction((oldValue, newValue) {
              final text = newValue.text;
              if (text.isEmpty) return newValue;
              final value = double.tryParse(text);
              if (value == null) return oldValue;
              return newValue;
            }),
          ],
          decoration: InputDecoration(
            hintText: hint,
            fillColor: fillColor,
            filled: fillColor != null,
            contentPadding: const EdgeInsets.only(left: AppSize.s),
          ),
          onChanged: listener,
          maxLines: 1,
        ),
      ),
    );
  }

  @override
  void dispose() {
    wController.dispose();
    hController.dispose();
    dController.dispose();
    super.dispose();
  }

  @override
  AppSizeFormField get widget => super.widget as AppSizeFormField;
}

/// ----------------------------------------------------------------------------
///                             EXPLICIT FIELDS
/// ----------------------------------------------------------------------------

class AppArtworkSizeField extends StatelessWidget {
  const AppArtworkSizeField({
    super.key,
    this.onChanged,
    this.initialValue,
  });

  final ArtworkSize? initialValue;
  final ValueChanged<ArtworkSize>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AppSizeFormField(
      initialValue: initialValue,
      onChanged: onChanged,
    );
  }
}
