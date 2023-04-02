import 'package:flutter/material.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/form/app_form.dart';
import 'package:myguide/ui/input/text.dart';

const _ffName = 'name';
const _ffURL = 'url';

extension AuthorFormValue on FormValue {
  set name(String? name) => this[_ffName] = name;

  set url(String? url) => this[_ffURL] = url;

  String? get name => this[_ffName];

  String? get url => this[_ffURL];
}

class AuthorForm extends StatefulWidget {
  AuthorForm({
    super.key,
    String? name,
    String? url,
    this.onSubmit,
  }) : value = {_ffName: name, _ffURL: url};

  final FormValue value;
  final ValueChanged<FormValue>? onSubmit;

  @override
  State<AuthorForm> createState() => _AuthorFormState();
}

class _AuthorFormState extends State<AuthorForm> {
  late final GlobalKey<AppFormState> formKey;
  late final FormValue value;

  @override
  void initState() {
    super.initState();
    value = Map.from(widget.value);
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
          initialValue: widget.value.name,
          hint: copy.authorName,
          onChanged: (name) => value.name = name,
        ),
        AppURLField(
          initialValue: widget.value.url,
          required: false,
          hint: copy.authorURL,
          onChanged: (url) => value.url = url,
        ),
        ElevatedButton(
          onPressed: widget.onSubmit == null ? null : onSubmit,
          child: Text(copy.confirm),
        ),
      ],
    );
  }
}
