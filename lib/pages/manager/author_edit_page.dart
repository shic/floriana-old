import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myguide/core/features/authentication/ui/auth_required_content.dart';
import 'package:myguide/core/features/author_management/controller.dart';
import 'package:myguide/core/features/author_management/domain.dart';
import 'package:myguide/core/features/author_management/ui/author_form.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/routing/router.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/scaffold/appbar.dart';
import 'package:myguide/ui/spacers.dart';

final getAuthorFuture =
    FutureProvider.autoDispose.family<Author, String>((ref, id) {
  final state = ref.watch(authorManagementProvider);
  final completer = Completer<Author>();
  state.maybeWhen(
    data: (authors) {
      final author = authors.firstWhere((element) => element.id == id);
      completer.complete(author);
    },
    error: completer.completeError,
    orElse: () {},
  );
  return completer.future;
});

class AuthorEditPage extends StatelessWidget {
  const AuthorEditPage({
    super.key,
    required this.id,
  });

  final String? id;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(title: copy.author),
      body: AuthRequired.manager(
        child: Consumer(
          builder: (_, ref, __) {
            return Padding(
              padding: MediaQuery.of(context).padding +
                  defaultTargetPlatform.when(
                    context: context,
                    mobile: AppInsets.page,
                    desktop: AppInsets.hpage +
                        EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * .2,
                        ),
                  ),
              child: id == null
                  ? AuthorForm(
                      onSubmit: (authorValue) async {
                        final goRouter = GoRouter.of(context);
                        await ref
                            .read(authorManagementProvider.notifier)
                            .createNewAuthor(
                              name: authorValue.name!,
                              url: authorValue.url,
                            );
                        goRouter.go('/manager/authors');
                      },
                    )
                  : ref.watch(getAuthorFuture(id!)).whenOrNull(
                        data: (author) {
                          return AuthorForm(
                            name: author.name,
                            url: author.url,
                            onSubmit: (authorValue) async {
                              final goRouter = GoRouter.of(context);
                              final newAuthor = Author(
                                id: author.id,
                                managerId: author.managerId,
                                name: authorValue.name!,
                                url: authorValue.url,
                              );
                              await ref
                                  .read(authorManagementProvider.notifier)
                                  .saveAuthor(newAuthor);
                              goRouter.pop();
                            },
                          );
                        },
                      ) ??
                      const SizedBox(),
            );
          },
        ),
      ),
    );
  }
}
