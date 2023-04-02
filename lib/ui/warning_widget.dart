import 'package:flutter/material.dart';
import 'package:myguide/ui/spacers.dart';

enum Severity {
  error,
  warning,
}

class MessageWidget extends StatelessWidget {
  const MessageWidget.error({
    super.key,
    required this.message,
  }) : severity = Severity.error;

  const MessageWidget.warning({
    super.key,
    required this.message,
  }) : severity = Severity.warning;

  final String message;
  final Severity severity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color color;
    switch (severity) {
      case Severity.error:
        color = theme.colorScheme.error;
        break;
      case Severity.warning:
        color = theme.colorScheme.tertiary;
        break;
    }

    return Row(
      children: [
        Icon(Icons.warning, size: 14, color: color),
        const AppSpacer.xs(),
        Expanded(
          child: Text(
            message,
            style: theme.textTheme.bodySmall!.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
