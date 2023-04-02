import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/authentication/all.dart';
import 'package:myguide/core/features/authentication/ui/logout_button.dart';
import 'package:myguide/core/features/user_management/all.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/form/profile_form.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/scaffold/appbar.dart';
import 'package:myguide/ui/spacers.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    Widget body = SingleChildScrollView(
      padding: MediaQuery.of(context).padding +
          defaultTargetPlatform.when(
            context: context,
            mobile: AppInsets.page,
            desktop: AppInsets.hpage +
                EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * .2,
                ),
          ),
      child: Consumer(
        builder: (_, ref, __) {
          final user = ref.watch(userProvider).value;
          if (user == null) return const SizedBox();
          return ProfileForm(
            initialValue: ProfileForm.buildValue(
              displayName: user.displayName,
              website: user.website,
            ),
            onSubmit: (value) async {
              final messenger = ScaffoldMessenger.of(context);
              await ref.read(userProvider.notifier).updateUser(
                    displayName: value.displayName,
                    avatar: value.avatar,
                    website: value.website,
                  );
              messenger.showSnackBar(
                SnackBar(
                  content: Text(copy.profileUpdated)
                ),
              );
            },
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppAppBar(
        title: copy.profile,
        actions: const [LogoutButton()],
      ),
      body: AuthRequired.user(child: body),
    );
  }
}
