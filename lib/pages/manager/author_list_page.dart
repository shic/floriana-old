import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myguide/core/features/authentication/ui/auth_required_content.dart';
import 'package:myguide/core/features/author_management/controller.dart';
import 'package:myguide/core/features/author_management/ui/author_list.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/pages/utils/provider.dart';
import 'package:myguide/routing/router.dart';
import 'package:myguide/routing/routes_manager.dart';
import 'package:myguide/ui/empty_state.dart';
import 'package:myguide/ui/list.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/scaffold/appbar.dart';
import 'package:myguide/ui/spacers.dart';

class AuthorListPage extends StatelessWidget {
  const AuthorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(
        title: copy.authors,
        actions: [
          CreateNewButton(
            path: AuthorEditRoute.route(),
          ),
        ],
      ),
      body: AuthRequired.manager(
        child: AppConsumerListWidget(
          padding: MediaQuery.of(context).padding +
              defaultTargetPlatform.when(
                context: context,
                mobile: AppInsets.page,
                desktop: AppInsets.hpage +
                    EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * .2,
                    ),
              ),
          provider: authorManagementProvider,
          emptyBuilder: (_) {
            return EmptyState.error(
              message: copy.noAuthorsAdded,
              action: ElevatedButton(
                onPressed: () => context.go(AuthorEditRoute.route()),
                child: Text(copy.create),
              ),
            );
          },
          dataBuilder: (context, authors) {
            return [
              SliverList(
                delegate: AuthorsChildBuilderDelegate(
                  authors: authors,
                  onDelete: (author) {
                    context
                        .read(authorManagementProvider.notifier)
                        .deleteAuthor(author);
                  },
                  onEdit: (author) {
                    context.go(AuthorEditRoute.route(id: author.id));
                  },
                ),
              )
            ];
          },
        ),
      ),
    );
  }
}
