import 'package:flutter/material.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/form/app_form.dart';
import 'package:myguide/ui/input/image.dart';
import 'package:myguide/ui/input/input.dart';
import 'package:myguide/ui/input/text.dart';

const _kDisplayName = 'display_name';
const _kAvatar = 'avatar';
const _kWebsite = 'website';

extension ProfileFormValue on FormValue {
  String? get displayName => this[_kDisplayName];

  String? get avatar => this[_kAvatar];

  String? get website => this[_kWebsite];

  set displayName(String? d) => this[_kDisplayName] = d;

  set avatar(String? a) => this[_kAvatar] = a;

  set website(String? w) => this[_kWebsite] = w;
}

class ProfileForm extends StatefulWidget {
  const ProfileForm({
    super.key,
    required this.initialValue,
    this.onSubmit,
  });

  final FormValue initialValue;
  final FormValueCallback? onSubmit;

  static FormValue buildValue({
    String? displayName,
    String? avatar,
    String? website,
  }) {
    return {_kDisplayName: displayName, _kAvatar: avatar, _kWebsite: website};
  }

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  late final GlobalKey<AppFormState> formKey;
  late final FormValue value;

  @override
  void initState() {
    super.initState();
    value = Map.from(widget.initialValue);
    formKey = GlobalKey();
  }

  void onSubmit() {
    if (formKey.currentState!.validate()) widget.onSubmit!(value);
  }

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return AppForm(
      key: formKey,
      children: [
        AppNameField(
          initialValue: widget.initialValue.displayName,
          onChanged: (d) => value.displayName = d,
          hint: copy.displayName,
        ),
        (value.avatar != null) && (value.avatar!.isNotEmpty)
            ? Input(
                label: copy.avatar,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppImageFormField(
                    initialValue: widget.initialValue.avatar,
                    onChanged: (a) => value.avatar = a,
                  ),
                ),
              )
            : const SizedBox(),
        AppURLField(
          initialValue: widget.initialValue.website,
          onChanged: (w) => value.website = w,
          hint: copy.website,
        ),
        ElevatedButton(
          onPressed: widget.onSubmit == null ? null : onSubmit,
          child: Text(copy.confirmChanges),
        ),
      ],
    );
  }
}
