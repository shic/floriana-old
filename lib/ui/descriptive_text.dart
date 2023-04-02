import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/spaced.dart';
import 'package:myguide/ui/spacers.dart';
import 'package:myguide/ui/tappable.dart';
import 'package:myguide/ui/theme.dart';
import 'package:url_launcher/url_launcher_string.dart';

class InformationHolder extends StatelessWidget {
  const InformationHolder({super.key, required this.infos});

  final List<Widget> infos;

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform.when(
      context: context,
      mobile: Column(
        children: infos.separated(
          separatorBuilder: () => const AppSpacer.xs(),
        ),
      ),
      desktop: _buildDesktopMode(),
    );
  }

  Widget _buildDesktopMode() {
    final column1Items = <Widget>[];
    final column2Items = <Widget>[];
    for (var i = 0; i < infos.length; i++) {
      final widget = infos[i];
      (i.isEven ? column1Items : column2Items).add(widget);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: column1Items.separated(
              separatorBuilder: () => const AppSpacer.xs(),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: column2Items.separated(
              separatorBuilder: () => const AppSpacer.xs(),
            ),
          ),
        ),
      ],
    );
  }
}

class DescriptiveText extends StatelessWidget {
  const DescriptiveText({
    super.key,
    required this.title,
    required this.content,
    this.link,
  });

  final String title;
  final String content;
  final String? link;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.tS;
    final contentStyle = theme.textTheme.bM.copyWith(
      color: theme.colorScheme.tertiary,
      decoration: link == null ? null : TextDecoration.underline,
    );

    final contentW = link == null
        ? Text(content, style: contentStyle)
        : Tappable(onTap: () => launchUrlString(link!), child: Text(content, style: contentStyle));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: titleStyle),
        contentW,
        const AppSpacer.xs(),
      ],
    );
  }
}
