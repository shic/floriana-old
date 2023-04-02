import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myguide/ui/spaced.dart';
import 'package:myguide/ui/spacers.dart';

typedef FormValue = Map<String, dynamic>;

typedef FormValueCallback = FutureOr<void> Function(FormValue);

class AppForm extends StatefulWidget {
  const AppForm({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  State<AppForm> createState() => AppFormState();
}

class AppFormState extends State<AppForm> {
  late final ValueNotifier<AutovalidateMode> autovalidateModeN;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    autovalidateModeN = ValueNotifier(AutovalidateMode.disabled);
    formKey = GlobalKey();
    super.initState();
  }

  @override
  void dispose() {
    autovalidateModeN.dispose();
    super.dispose();
  }

  bool validate() {
    autovalidateModeN.value = AutovalidateMode.always;
    return formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AutovalidateMode>(
      valueListenable: autovalidateModeN,
      builder: (_, autovalidateMode, child) {
        return Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: child!,
        );
      },
      child: SeparatedColumn(
        separatorBuilder: () => const AppSpacer.m(),
        children: widget.children,
      ),
    );
  }
}
