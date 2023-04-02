import 'package:myguide/core/services/auth_service.dart';
import 'package:myguide/l10n/l10n.dart';

class ErrorFormatter {

  ErrorFormatter._();

  static String formatError(dynamic error, {required AppLocalizations copy}) {
    if (error is AuthError) {
      switch (error) {
        case AuthError.userNotFound:
        case AuthError.wrongPassword:
          return copy.userDoesNotExist;
        case AuthError.userAlreadyExists:
          return copy.userAlreadyExists;
        case AuthError.unknown:
          return copy.somethingUnexpectedHappened;
      }
    }
    return copy.somethingUnexpectedHappened;
  }

}
