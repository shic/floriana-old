import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/error_formatter.dart';
import 'package:myguide/ui/loading.dart';

extension AsyncThrowable on BuildContext {

  Future<void> guardThrowable({required Future Function() operation}) async {
    final loader = PageLoader.of(this);
    loader.setLoading(true);
    try {
      await operation();
    } catch (error) {
      showErrorDialog(error: error);
    } finally {
      loader.setLoading(false);
    }
  }
}

extension DialogX on BuildContext {

  Future<void> showErrorDialog({required Object error}) {
    final copy = AppLocalizations.of(this)!;
    return AwesomeDialog(
      context: this,
      dialogType: DialogType.error,
      title: copy.error,
      desc: ErrorFormatter.formatError(error, copy: copy),
      width: 500,
      headerAnimationLoop: false,
      useRootNavigator: true,
    ).show();
  }
}
