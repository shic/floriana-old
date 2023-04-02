import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/input/input.dart';
import 'package:myguide/ui/spacers.dart';
import 'package:myguide/ui/theme.dart';

class Option<T> {
  final String label;
  final T value;

  const Option({
    required this.label,
    required this.value,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Option &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class OptionFormField<T> extends FormField<T> {
  OptionFormField({
    super.key,
    super.initialValue,
    required String label,
    required List<Option<T>> options,
    required ValueChanged<T> onChanged,
    super.validator,
  }) : super(
          builder: (state) {
            final values = {
              for (final option in options) option: option.value == state.value
            };
            return Input(
              label: label,
              child: OptionField(
                options: values,
                onChanged: (newValue) {
                  state.didChange(newValue);
                  onChanged(newValue);
                },
              ),
            );
          },
        );
}

class ScreenOptionFormField<T> extends FormField<T> {
  ScreenOptionFormField({
    super.key,
    super.initialValue,
    required String label,
    required List<Option<T>> options,
    required ValueChanged<T> onChanged,
    super.validator,
  }) : super(
          builder: (state) {
            final values = {
              for (final option in options) option: option.value == state.value
            };
            final selected = values.keys.firstWhereOrNull((k) => values[k]!);
            return Input(
              label: label,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    final newValue = await Navigator.of(state.context).push(
                      MaterialPageRoute(
                        builder: (_) => _OptionScreen(options: values),
                      ),
                    );
                    if (newValue == null) return;
                    state.didChange(newValue);
                    onChanged(newValue);
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(hintText: label),
                    child: Padding(
                      padding: AppInsets.s,
                      child: selected == null
                          ? const SizedBox()
                          : Text(selected.label),
                    ),
                  ),
                ),
              ),
            );
          },
        );
}

class _OptionScreen<T> extends StatelessWidget {
  const _OptionScreen({
    super.key,
    required this.options,
  });

  final Map<Option<T>, bool> options;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    final keys = options.keys;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(copy.select),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final option = keys.elementAt(index);
                return ListTile(
                  title: Text(option.label),
                  onTap: () {
                    T? returnValue;
                    if (option !=
                        options.keys.firstWhereOrNull((e) => options[e]!)) {
                      returnValue = option.value;
                    }
                    Navigator.of(context).pop(returnValue);
                  },
                );
              },
              childCount: keys.length,
            ),
          ),
        ],
      ),
    );
  }
}

class OptionField<T> extends StatelessWidget {
  const OptionField({
    super.key,
    required this.options,
    required this.onChanged,
  });

  final Map<Option<T>, bool> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupValue = options.entries.firstWhereOrNull((e) => e.value)?.key;
    return CupertinoSegmentedControl<Option<T>>(
      children: options.map(
        (option, selected) {
          return MapEntry(
            option,
            Container(
              color: Colors.transparent,
              padding: AppInsets.hm.add(AppInsets.vs),
              child: Text(
                option.label,
                style: selected ? theme.textTheme.tM : theme.textTheme.bL,
              ),
            ),
          );
        },
      ),
      borderColor: null,
      selectedColor: theme.colorScheme.surface,
      unselectedColor: theme.colorScheme.background,
      padding: AppInsets.xl,
      groupValue: groupValue,
      onValueChanged: (newValue) {
        if (groupValue?.value == newValue.value) return;
        onChanged(newValue.value);
      },
    );
  }
}
