import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/spacers.dart';
import 'package:myguide/ui/theme.dart';

enum _EmptyStateType {
  loading,
  error,
}

class EmptyState extends StatelessWidget {
  const EmptyState.loading({
    super.key,
  })  : message = null,
        action = null,
        _type = _EmptyStateType.loading;

  const EmptyState.error({
    super.key,
    required String this.message,
    this.action,
  }) : _type = _EmptyStateType.error;

  final _EmptyStateType _type;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final copy = AppLocalizations.of(context)!;
    final colorScheme = theme.colorScheme;
    final Widget childWidget;
    final String message;
    final tintColor = colorScheme.tertiary;
    switch (_type) {
      case _EmptyStateType.loading:
        childWidget = Padding(
          padding: const EdgeInsets.all(50),
          child: LoadingAnimationWidget.threeArchedCircle(
            color: tintColor,
            size: 100,
          ),
        );
        message = copy.loading;
        break;
      case _EmptyStateType.error:
        childWidget = Icon(
          Icons.error_outline_outlined,
          color: tintColor,
          size: 100,
        );
        message = this.message!;
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Center(child: childWidget),
        const AppSpacer.s(),
        Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bL.copyWith(color: tintColor),
        ),
        if (action != null) ...[
          const AppSpacer.s(),
          Center(child: action!),
        ],
      ],
    );
  }
}
