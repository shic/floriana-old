import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/author_management/controller.dart';
import 'package:myguide/core/features/author_management/domain.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/descriptive_text.dart';

final _authorByIdProvider =
    FutureProvider.autoDispose.family<Author?, String>((ref, id) {
  return ref.watch(authorManagementProvider.notifier).getAuthor(id);
});

class AuthorName extends ConsumerWidget {
  const AuthorName({
    super.key,
    required this.authorId,
  });

  final String? authorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    if (authorId == null) {
      return DescriptiveText(
        title: copy.author,
        content: copy.unknown,
      );
    }

    return DescriptiveText(
      title: copy.author,
      content: authorId ?? "",
      link: null,
    );
  }
}
