import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/app_image.dart';
import 'package:myguide/ui/empty_state.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/spacers.dart';
import 'package:myguide/ui/theme.dart';
import 'package:myguide/ui/warning_widget.dart';

typedef AppErrorBuilder = Widget Function(BuildContext, Object);
typedef AppWidgetBuilder<T> = Widget Function(BuildContext, T);
typedef AppWidgetListBuilder<T> = List<Widget> Function(
    BuildContext, Iterable<T>);

typedef DelegatesBuilder<T> = Iterable<SliverChildBuilderDelegate> Function(
    Iterable<T>);

class AppConsumerWidget<T> extends ConsumerWidget {
  const AppConsumerWidget({
    super.key,
    required this.provider,
    required this.dataBuilder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  final ProviderBase<AsyncValue<T>> provider;
  final AppWidgetBuilder<T> dataBuilder;
  final WidgetBuilder? loadingBuilder;
  final AppErrorBuilder? errorBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(provider).when(
          data: (data) => dataBuilder(context, data),
          error: (error, stacktrace) {
            debugPrint(error.toString());
            debugPrintStack(
                stackTrace: stacktrace, label: runtimeType.toString());
            if (errorBuilder == null) {
              return MessageWidget.error(message: error.toString());
            }
            return errorBuilder!.call(context, error);
          },
          loading: () {
            if (loadingBuilder == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return loadingBuilder!.call(context);
          },
        );
  }
}

class AppConsumerListWidget<T> extends AppConsumerWidget<Iterable<T>> {
  AppConsumerListWidget({
    super.key,
    required super.provider,
    required AppWidgetListBuilder<T> dataBuilder,
    EdgeInsets? padding,
    WidgetBuilder? emptyBuilder,
    AppErrorBuilder? errorBuilder,
    WidgetBuilder? loadingBuilder,
  }) : super(
          dataBuilder: (context, data) {
            final copy = AppLocalizations.of(context)!;
            if (data.isEmpty) {
              if (emptyBuilder == null) {
                return EmptyState.error(message: copy.empty);
              }
              return emptyBuilder(context);
            }
            final slivers = dataBuilder(context, data);
            return CustomScrollView(
              slivers: [
                if (padding?.top != null)
                  SliverToBoxAdapter(child: SizedBox(height: padding!.top)),
                ...List.generate(
                  slivers.length,
                  (index) {
                    final sliver = slivers[index];
                    if (padding == null) return sliver;
                    return SliverPadding(
                      padding: EdgeInsets.only(
                          left: padding.left, right: padding.right),
                      sliver: sliver,
                    );
                  },
                ),
                if (padding?.bottom != null)
                  SliverToBoxAdapter(child: SizedBox(height: padding!.bottom)),
              ],
            );
          },
          loadingBuilder: loadingBuilder,
          errorBuilder: errorBuilder,
        );
}

class AppCollapsibleAppBarBody extends StatelessWidget {
  const AppCollapsibleAppBarBody({
    super.key,
    required this.imageURL,
    required this.body,
  });

  final String? imageURL;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: MediaQuery.of(context).size.height * .35,
            floating: false,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: imageURL == null
                  ? null
                  : BlurredBackgroundImage(url: imageURL!),
            ),
          ),
        ];
      },
      body: body,
    );
  }
}

enum _DashboardListItemType {
  create,
  custom,
}

class DashboardListItem extends StatelessWidget {
  DashboardListItem.createNew({
    super.key,
    required String createNewPath,
    required BuildContext context,
  })  : title = '',
        _type = _DashboardListItemType.create,
        infos = null,
        actions = [CreateNewButton(path: createNewPath)],
        onTap = null;

  const DashboardListItem({
    super.key,
    this.onTap,
    required this.title,
    this.infos,
    this.actions = const [],
  }) : _type = _DashboardListItemType.custom;

  final VoidCallback? onTap;
  final _DashboardListItemType _type;
  final String title;
  final List<String>? infos;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final copy = AppLocalizations.of(context)!;
    final textTheme = theme.textTheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 64,
      ),
      child: Material(
        color: theme.colorScheme.surface,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: AppInsets.hm.add(AppInsets.vxs),
            child: Row(
              children: [
                Expanded(
                  child: Text(_type == _DashboardListItemType.custom ? title: copy.create, style: textTheme.tS),
                ),
                if (infos != null) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: infos!
                          .map((e) => Text(
                                e,
                                style: textTheme.bS,
                                maxLines: 2,
                              ))
                          .toList(),
                    ),
                  ),
                ],
                if (actions.isNotEmpty) ...[
                  const AppSpacer.xs(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditDashboardItemButton extends StatelessWidget {
  const EditDashboardItemButton({super.key, required this.onEdit});

  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onEdit,
      icon: Icon(Icons.edit,color: Theme.of(context).colorScheme.tertiary),
    );
  }
}

class DeleteDashboardItemButton extends StatelessWidget {
  const DeleteDashboardItemButton({super.key, required this.onDelete});

  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: onDelete,
      icon: Icon(Icons.delete, color: colorScheme.error),
    );
  }
}

class InfoItem extends StatelessWidget {
  const InfoItem({
    super.key,
    required this.title,
    required this.value,
    this.axis = Axis.vertical,
  });

  final String title;
  final String value;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleW = Text(title, style: theme.textTheme.hS);
    final valueW = Text(value, style: theme.textTheme.bM);
    switch (axis) {
      case Axis.horizontal:
        return Row(children: [titleW, Expanded(child: valueW)]);
      case Axis.vertical:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [titleW, valueW],
        );
    }
  }
}
