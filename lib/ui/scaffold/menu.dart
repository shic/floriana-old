import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myguide/ui/assets.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/spacers.dart';
import 'package:myguide/ui/theme.dart';

class AppScaffoldMenuItem extends StatelessWidget {
  const AppScaffoldMenuItem({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final style = selected
        ? textTheme.tM.copyWith(color: colorScheme.primary)
        : textTheme.tS;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: AppInsets.hm + AppInsets.vs,
          child: Text(title, style: style),
        ),
      ),
    );
  }
}

class AppScaffoldMenu extends StatelessWidget {
  const AppScaffoldMenu({Key? key, required this.items, required this.roleChangeItem,}) : super(key: key);

  final Iterable<AppScaffoldMenuItem> items;
  final Widget roleChangeItem;

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform.when(
      context: context,
      mobile: _buildMobile(context),
      desktop: _buildDesktop(context),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const AppSpacer.m(),
        Center(child: Logo.build(width: 180)),
        const AppSpacer.m(),
        Container(
          width: 180,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border.all(color: theme.colorScheme.surface),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [

              roleChangeItem,
              ...items,
              const AppSpacer.s(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppSpacer.m(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Logo.build(width: 150)],
          ),
          const AppSpacer.m(),
          roleChangeItem,
          ...items,
        ],
      ),
    );
  }

}

