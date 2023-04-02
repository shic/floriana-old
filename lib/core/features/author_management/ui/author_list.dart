import 'package:flutter/material.dart';
import 'package:myguide/core/features/author_management/all.dart';
import 'package:myguide/ui/list.dart';
import 'package:myguide/ui/spacers.dart';

class AuthorsChildBuilderDelegate extends SliverChildBuilderDelegate {
  AuthorsChildBuilderDelegate({
    required Iterable<Author> authors,
    required ValueChanged<Author> onEdit,
    required ValueChanged<Author> onDelete,
  }) : super(
          (_, i) {
            if (i.isOdd) return const AppSpacer.xs();
            final author = authors.elementAt(i ~/ 2);
            return AuthorDashboardListItem(
              author: author,
              onEdit: () => onEdit(author),
              onDelete: () => onDelete(author),
            );
          },
          childCount: authors.length * 2 - 1,
          semanticIndexCallback: (_, i) => i.isEven ? i ~/ 2 : null,
        );
}

class AuthorDashboardListItem extends StatelessWidget {
  const AuthorDashboardListItem({
    super.key,
    required this.author,
    required this.onEdit,
    required this.onDelete,
  });

  final Author author;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return DashboardListItem(
      title: author.name,
      infos: author.url == null ? null : [author.url!],
      actions: [
        EditDashboardItemButton(onEdit: onEdit),
        DeleteDashboardItemButton(onDelete: onDelete),
      ],
    );
  }
}
