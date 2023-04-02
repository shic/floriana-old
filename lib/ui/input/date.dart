import 'package:flutter/material.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/input/input.dart';
import 'package:myguide/ui/spacers.dart';

class AppDateFormField extends FormField<DateTime?> {
  AppDateFormField({
    super.key,
    DateTime? initialValue,
    String? Function(DateTime?)? validator,
    ValueChanged<DateTime>? onChanged,
    required String hint,
    String? description,
  }) : super(
          initialValue: initialValue,
          enabled: onChanged != null,
          validator: validator == null ? null : (value) => validator(value),
          builder: (state) {
            final theme = Theme.of(state.context);
            final inputDecorTheme = theme.inputDecorationTheme;

            final fillColor =
                state.hasError ? theme.colorScheme.error.withOpacity(.1) : null;

            return AppDateField(
              hint: hint,
              onSelect: (value) {
                state.didChange(value);
                onChanged?.call(value);
              },
              fillColor: fillColor,
              value: state.value,
            );
          },
        );
}

class AppDateRangeFormField extends FormField<DateTimeRange?> {
  AppDateRangeFormField({
    super.key,
    DateTimeRange? initialValue,
    String? Function(DateTimeRange?)? validator,
    ValueChanged<DateTimeRange>? onChanged,
    required String hint,
    String? description,
  }) : super(
          initialValue: initialValue,
          enabled: onChanged != null,
          validator: validator == null ? null : (value) => validator(value),
          builder: (state) {
            final theme = Theme.of(state.context);
            final inputDecorTheme = theme.inputDecorationTheme;

            final fillColor =
                state.hasError ? theme.colorScheme.error.withOpacity(.1) : null;

            return AppDateRangeField(
              hint: hint,
              onSelect: (value) {
                state.didChange(value);
                onChanged?.call(value);
              },
              fillColor: fillColor,
              value: state.value,
            );
          },
        );
}

class AppDateRangeField extends StatelessWidget {
  const AppDateRangeField({
    super.key,
    required this.hint,
    this.value,
    this.onSelect,
    this.fillColor,
  });

  final String hint;
  final DateTimeRange? value;
  final ValueChanged<DateTimeRange>? onSelect;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    final String? stringValue;
    if (value == null) {
      stringValue = null;
    } else {
      stringValue = copy.fromToYMMMMEEEEd(
        value!.start.toUtc(),
        value!.end.toUtc(),
      );
    }
    return Input(
      label: hint,
      child: Material(
        child: InkWell(
          onTap: onSelect == null
              ? null
              : () async {
                  final now = DateTime.now();
                  final firstDate = value?.start == null
                      ? now
                      : value!.start.isBefore(now)
                          ? value!.start
                          : now;
                  final date = await showDateRangePicker(
                    context: context,
                    initialDateRange: value,
                    currentDate: DateTime.now(),
                    firstDate: firstDate,
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date == null) return;
                  final utcRange = DateTimeRange(
                    start: DateTime.utc(
                      date.start.year,
                      date.start.month,
                      date.start.day,
                    ),
                    end: DateTime.utc(
                      date.end.year,
                      date.end.month,
                      date.end.day,
                      23,
                      59,
                      59,
                    ),
                  );
                  onSelect!.call(utcRange);
                },
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: value == null ? hint : null,
              fillColor: fillColor,
              isDense: false,
              filled: true,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: AppSize.s),
              child: stringValue == null ? null : Text(stringValue),
            ),
          ),
        ),
      ),
    );
  }
}

class AppDateField extends StatelessWidget {
  const AppDateField({
    super.key,
    required this.hint,
    this.value,
    this.onSelect,
    this.fillColor,
  });

  final String hint;
  final DateTime? value;
  final ValueChanged<DateTime>? onSelect;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSelect == null
            ? null
            : () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: value ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) onSelect!.call(date);
              },
        child: InputDecorator(
          decoration: InputDecoration(
            hintText: value == null ? hint : null,
            fillColor: fillColor,
            isDense: true,
          ),
          child: value == null ? null : Center(child: Text(value!.toString())),
        ),
      ),
    );
  }
}

/// ----------------------------------------------------------------------------
///                             EXPLICIT FIELDS
/// ----------------------------------------------------------------------------
