import 'package:flutter/material.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/input/input.dart';
import 'package:myguide/ui/input/option.dart';
import 'package:myguide/ui/spacers.dart';

class SelectFormField<T> extends FormField<Iterable<T>> {
  SelectFormField({
    super.key,
    super.initialValue,
    required String label,
    required List<Option<T>> options,
    required ValueChanged<Iterable<T>> onChanged,
    super.validator,
  }) : super(
          builder: (state) {
            final values = {
              for (final option in options)
                option: state.value!.contains(option.value),
            };
            return Input(
              label: label,
              child: SelectField(
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

class ScreenSelectFormField<T> extends FormField<Iterable<T>> {
  ScreenSelectFormField({
    super.key,
    super.initialValue,
    required String label,
    required List<Option<T>> options,
    required ValueChanged<Iterable<T>> onChanged,
    super.validator,
  }) : super(
          builder: (state) {
            final copy = AppLocalizations.of(state.context)!;
            final values = {
              for (final option in options)
                option: state.value!.contains(option.value),
            };
            final selected = values.keys.where((k) => values[k]!);
            return Input(
              label: label,
              child: Material(
                child: InkWell(
                  onTap: () async {
                    final newValue = await Navigator.of(state.context).push(
                      MaterialPageRoute(
                        builder: (_) => _SelectScreen(options: values),
                      ),
                    );
                    if (newValue == null) return;
                    state.didChange(newValue);
                    onChanged(newValue);
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      hintText: label,
                      filled: true,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: AppSize.s),
                      child: Text(copy.selected(selected.length)),
                    ),
                  ),
                ),
              ),
            );
          },
        );
}

class _SelectScreen<T> extends StatefulWidget {
  const _SelectScreen({
    super.key,
    required this.options,
  });

  final Map<Option<T>, bool> options;

  @override
  State<_SelectScreen<T>> createState() => _SelectScreenState<T>();
}

class _SelectScreenState<T> extends State<_SelectScreen<T>> {
  late final Map<Option<T>, bool> options;

  @override
  void initState() {
    super.initState();
    options = Map.from(widget.options);
  }

  @override
  Widget build(BuildContext context) {
    final keys = options.keys;
    final copy = AppLocalizations.of(context)!;
    final theme = Theme.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(copy.select),
        actions: [
          TextButton(
            child: Text(
              copy.ok.toUpperCase(),
              style: theme.textTheme.titleLarge,
            ),
            onPressed: () => Navigator.of(context).pop(
              keys.where((k) => options[k]!).map((e) => e.value),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final key = keys.elementAt(index);
                return CheckboxListTile(
                  title: Text(key.label),
                  value: options[key],
                  checkColor: Theme.of(context).colorScheme.tertiary,
                  activeColor: Theme.of(context).colorScheme.surface,
                  onChanged: (v) {
                    setState(() => options[key] = !options[key]!);
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

class SelectField<T> extends StatelessWidget {
  const SelectField({
    super.key,
    required this.options,
    required this.onChanged,
  });

  final Map<Option<T>, bool> options;
  final ValueChanged<Iterable<T>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.keys.map((key) {
        return CheckboxListTile(
          title: Text(key.label),
          value: options[key],
          onChanged: (v) {
            options[key] = !options[key]!;
            onChanged(
                options.keys.where((k) => options[k]!).map((e) => e.value));
          },
        );
      }).toList(),
    );
  }
}
