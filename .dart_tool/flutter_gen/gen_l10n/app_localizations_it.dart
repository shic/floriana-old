import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get ok => 'Ok';

  @override
  String get confirm => 'Conferma';

  @override
  String get home => 'Home';

  @override
  String get create => 'Crea';

  @override
  String get show => 'Mostra';

  @override
  String get unknown => 'Sconosciuto';

  @override
  String get hide => 'Nascondi';

  @override
  String get required => 'Richiesto';

  @override
  String get confirmChanges => 'Conferma i cambiamenti';

  @override
  String get website => 'Sito web';

  @override
  String get websiteErrorNotValid => 'Questo sito non è valido';

  @override
  String get description => 'Descrizione';

  @override
  String get images => 'Immagini';

  @override
  String get nameInvalidStart => 'Il nome può iniziare con una lettera, un numero o _';

  @override
  String get nameInvalidEnd => 'Il nome può finire con una lettera, un numero o _';

  @override
  String get navigateAsUser => 'Naviga come utente';

  @override
  String get navigateAsManager => 'Naviga come manager';

  @override
  String get error => 'Errore';

  @override
  String get loading => 'Caricamento';

  @override
  String get empty => 'Nessun elemento trovato';

  @override
  String get userDoesNotExist => 'Le credenziali inserite non sono corrette';

  @override
  String get userAlreadyExists => 'Un utente con questa email già esiste';

  @override
  String get somethingUnexpectedHappened => 'È accaduto qualcosa di inaspettato';

  @override
  String get login => 'Accedi';

  @override
  String get email => 'Email';

  @override
  String get invalidEmail => 'Email non valida';

  @override
  String get password => 'Password';

  @override
  String get passwordError6Chars => 'La password dev\'essere lunga almeno 6 caratteri';

  @override
  String get passwordErrorWhitespaces => 'La password non deve contenere spazi';

  @override
  String get repeatPassword => 'Ripeti password';

  @override
  String get repeatPasswordErrorDoesNotMatch => 'Le 2 password inserite non corrispondono';

  @override
  String get dontHaveAnAccount => 'Non hai un account?';

  @override
  String get alreadyHaveAnAccount => 'Hai già un account?';

  @override
  String get signup => 'Registrati';

  @override
  String get displayName => 'Nome';

  @override
  String get avatar => 'Avatar';

  @override
  String get logo => 'Logo';

  @override
  String get profile => 'Profilo';

  @override
  String get changePassword => 'Cambia password';

  @override
  String get profileUpdated => 'Profilo aggiornato';

  @override
  String get author => 'Autore';

  @override
  String get authors => 'Autori';

  @override
  String get authorSelect => 'Seleziona authore';

  @override
  String get visibilitySelect => 'Seleziona visibilità';

  @override
  String get authorName => 'Nome dell\'autore';

  @override
  String get authorURL => 'URL dell\'autore';

  @override
  String get authorURLMissing => 'Manca l\'URL dell\'autore';

  @override
  String get noAuthorsAdded => 'Non è ancora stato aggiunto nessun autore';

  @override
  String get favorites => 'Preferiti';

  @override
  String get monument => 'Monumento';

  @override
  String get monuments => 'Monumenti';

  @override
  String get artwork => 'Opera d\'arte';

  @override
  String get artworks => 'Opere d\'arte';

  @override
  String get noArtworkAdded => 'Nessuna opera d\'arte';

  @override
  String get artworkName => 'Nome dell\'opera';

  @override
  String get openSeaURL => 'URL di OpenSea';

  @override
  String get material => 'Materiale';

  @override
  String get sizeInCentimeters => 'Dimensioni (in centimetri)';

  @override
  String get height => 'Altezza';

  @override
  String get width => 'Larghezza';

  @override
  String get depth => 'Profondità';

  @override
  String get date => 'Data';

  @override
  String get creationPlace => 'Posto di realizzazione';

  @override
  String get creationYear => 'Anno di realizzazione';

  @override
  String get notVisible => 'Non visibile';

  @override
  String get visible => 'Visibile';

  @override
  String get costInEur => 'Prezzo in euro';

  @override
  String get select => 'Seleziona';

  @override
  String get imageSelect => 'Seleziona immagine';

  @override
  String get rangeSelect => 'Seleziona intervallo';

  @override
  String get artworkSelect => 'Seleziona opera d\'arte';

  @override
  String get imagesNotSet => 'Non ci sono immagini impostate';

  @override
  String get authorNotSet => 'Non è stato impostato un autore';

  @override
  String get exhibitionName => 'Nome della mostra';

  @override
  String get address => 'Indirizzo';

  @override
  String get showMore => 'Mostra di più';

  @override
  String get phoneNumber => 'Numero di telefono';

  @override
  String get exhibition => 'Mostra';

  @override
  String get exhibitions => 'Mostre';

  @override
  String get cost => 'Costo';

  @override
  String costInMoney(num money) {
    final intl.NumberFormat moneyNumberFormat = intl.NumberFormat.currency(
      locale: localeName,
      
    );
    final String moneyString = moneyNumberFormat.format(money);

    String _temp0 = intl.Intl.pluralLogic(
      money,
      locale: localeName,
      other: '$moneyString',
      zero: 'Gratis',
    );
    return '$_temp0';
  }

  @override
  String fromToYMMMMEEEEd(DateTime start, DateTime end) {
    final intl.DateFormat startDateFormat = intl.DateFormat.yMMMMEEEEd(localeName);
    final String startString = startDateFormat.format(start);
    final intl.DateFormat endDateFormat = intl.DateFormat.yMMMMEEEEd(localeName);
    final String endString = endDateFormat.format(end);

    return 'Da $startString a $endString';
  }

  @override
  String fromToMMMMd(DateTime start, DateTime end) {
    final intl.DateFormat startDateFormat = intl.DateFormat.MMMMd(localeName);
    final String startString = startDateFormat.format(start);
    final intl.DateFormat endDateFormat = intl.DateFormat.MMMMd(localeName);
    final String endString = endDateFormat.format(end);

    return '$startString - $endString';
  }

  @override
  String organizedBy(String org) {
    return 'Organizzato da $org';
  }

  @override
  String selected(int number) {
    return 'Selezionati: $number';
  }
}
