import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_it.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('it')
  ];

  /// No description provided for @ok.
  ///
  /// In it, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @confirm.
  ///
  /// In it, this message translates to:
  /// **'Conferma'**
  String get confirm;

  /// No description provided for @home.
  ///
  /// In it, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @create.
  ///
  /// In it, this message translates to:
  /// **'Crea'**
  String get create;

  /// No description provided for @show.
  ///
  /// In it, this message translates to:
  /// **'Mostra'**
  String get show;

  /// No description provided for @unknown.
  ///
  /// In it, this message translates to:
  /// **'Sconosciuto'**
  String get unknown;

  /// No description provided for @hide.
  ///
  /// In it, this message translates to:
  /// **'Nascondi'**
  String get hide;

  /// No description provided for @required.
  ///
  /// In it, this message translates to:
  /// **'Richiesto'**
  String get required;

  /// No description provided for @confirmChanges.
  ///
  /// In it, this message translates to:
  /// **'Conferma i cambiamenti'**
  String get confirmChanges;

  /// No description provided for @website.
  ///
  /// In it, this message translates to:
  /// **'Sito web'**
  String get website;

  /// No description provided for @websiteErrorNotValid.
  ///
  /// In it, this message translates to:
  /// **'Questo sito non è valido'**
  String get websiteErrorNotValid;

  /// No description provided for @description.
  ///
  /// In it, this message translates to:
  /// **'Descrizione'**
  String get description;

  /// No description provided for @images.
  ///
  /// In it, this message translates to:
  /// **'Immagini'**
  String get images;

  /// No description provided for @nameInvalidStart.
  ///
  /// In it, this message translates to:
  /// **'Il nome può iniziare con una lettera, un numero o _'**
  String get nameInvalidStart;

  /// No description provided for @nameInvalidEnd.
  ///
  /// In it, this message translates to:
  /// **'Il nome può finire con una lettera, un numero o _'**
  String get nameInvalidEnd;

  /// No description provided for @navigateAsUser.
  ///
  /// In it, this message translates to:
  /// **'Naviga come utente'**
  String get navigateAsUser;

  /// No description provided for @navigateAsManager.
  ///
  /// In it, this message translates to:
  /// **'Naviga come manager'**
  String get navigateAsManager;

  /// No description provided for @error.
  ///
  /// In it, this message translates to:
  /// **'Errore'**
  String get error;

  /// No description provided for @loading.
  ///
  /// In it, this message translates to:
  /// **'Caricamento'**
  String get loading;

  /// No description provided for @empty.
  ///
  /// In it, this message translates to:
  /// **'Nessun elemento trovato'**
  String get empty;

  /// No description provided for @userDoesNotExist.
  ///
  /// In it, this message translates to:
  /// **'Le credenziali inserite non sono corrette'**
  String get userDoesNotExist;

  /// No description provided for @userAlreadyExists.
  ///
  /// In it, this message translates to:
  /// **'Un utente con questa email già esiste'**
  String get userAlreadyExists;

  /// No description provided for @somethingUnexpectedHappened.
  ///
  /// In it, this message translates to:
  /// **'È accaduto qualcosa di inaspettato'**
  String get somethingUnexpectedHappened;

  /// No description provided for @login.
  ///
  /// In it, this message translates to:
  /// **'Accedi'**
  String get login;

  /// No description provided for @email.
  ///
  /// In it, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @invalidEmail.
  ///
  /// In it, this message translates to:
  /// **'Email non valida'**
  String get invalidEmail;

  /// No description provided for @password.
  ///
  /// In it, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordError6Chars.
  ///
  /// In it, this message translates to:
  /// **'La password dev\'essere lunga almeno 6 caratteri'**
  String get passwordError6Chars;

  /// No description provided for @passwordErrorWhitespaces.
  ///
  /// In it, this message translates to:
  /// **'La password non deve contenere spazi'**
  String get passwordErrorWhitespaces;

  /// No description provided for @repeatPassword.
  ///
  /// In it, this message translates to:
  /// **'Ripeti password'**
  String get repeatPassword;

  /// No description provided for @repeatPasswordErrorDoesNotMatch.
  ///
  /// In it, this message translates to:
  /// **'Le 2 password inserite non corrispondono'**
  String get repeatPasswordErrorDoesNotMatch;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In it, this message translates to:
  /// **'Non hai un account?'**
  String get dontHaveAnAccount;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In it, this message translates to:
  /// **'Hai già un account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @signup.
  ///
  /// In it, this message translates to:
  /// **'Registrati'**
  String get signup;

  /// No description provided for @displayName.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get displayName;

  /// No description provided for @avatar.
  ///
  /// In it, this message translates to:
  /// **'Avatar'**
  String get avatar;

  /// No description provided for @logo.
  ///
  /// In it, this message translates to:
  /// **'Logo'**
  String get logo;

  /// No description provided for @profile.
  ///
  /// In it, this message translates to:
  /// **'Profilo'**
  String get profile;

  /// No description provided for @changePassword.
  ///
  /// In it, this message translates to:
  /// **'Cambia password'**
  String get changePassword;

  /// No description provided for @profileUpdated.
  ///
  /// In it, this message translates to:
  /// **'Profilo aggiornato'**
  String get profileUpdated;

  /// No description provided for @author.
  ///
  /// In it, this message translates to:
  /// **'Autore'**
  String get author;

  /// No description provided for @authors.
  ///
  /// In it, this message translates to:
  /// **'Autori'**
  String get authors;

  /// No description provided for @authorSelect.
  ///
  /// In it, this message translates to:
  /// **'Seleziona authore'**
  String get authorSelect;

  /// No description provided for @visibilitySelect.
  ///
  /// In it, this message translates to:
  /// **'Seleziona visibilità'**
  String get visibilitySelect;

  /// No description provided for @authorName.
  ///
  /// In it, this message translates to:
  /// **'Nome dell\'autore'**
  String get authorName;

  /// No description provided for @authorURL.
  ///
  /// In it, this message translates to:
  /// **'URL dell\'autore'**
  String get authorURL;

  /// No description provided for @authorURLMissing.
  ///
  /// In it, this message translates to:
  /// **'Manca l\'URL dell\'autore'**
  String get authorURLMissing;

  /// No description provided for @noAuthorsAdded.
  ///
  /// In it, this message translates to:
  /// **'Non è ancora stato aggiunto nessun autore'**
  String get noAuthorsAdded;

  /// No description provided for @favorites.
  ///
  /// In it, this message translates to:
  /// **'Preferiti'**
  String get favorites;

  /// No description provided for @monument.
  ///
  /// In it, this message translates to:
  /// **'Monumento'**
  String get monument;

  /// No description provided for @monuments.
  ///
  /// In it, this message translates to:
  /// **'Monumenti'**
  String get monuments;

  /// No description provided for @artwork.
  ///
  /// In it, this message translates to:
  /// **'Opera d\'arte'**
  String get artwork;

  /// No description provided for @artworks.
  ///
  /// In it, this message translates to:
  /// **'Opere d\'arte'**
  String get artworks;

  /// No description provided for @noArtworkAdded.
  ///
  /// In it, this message translates to:
  /// **'Nessuna opera d\'arte'**
  String get noArtworkAdded;

  /// No description provided for @artworkName.
  ///
  /// In it, this message translates to:
  /// **'Nome dell\'opera'**
  String get artworkName;

  /// No description provided for @openSeaURL.
  ///
  /// In it, this message translates to:
  /// **'URL di OpenSea'**
  String get openSeaURL;

  /// No description provided for @material.
  ///
  /// In it, this message translates to:
  /// **'Materiale'**
  String get material;

  /// No description provided for @sizeInCentimeters.
  ///
  /// In it, this message translates to:
  /// **'Dimensioni (in centimetri)'**
  String get sizeInCentimeters;

  /// No description provided for @height.
  ///
  /// In it, this message translates to:
  /// **'Altezza'**
  String get height;

  /// No description provided for @width.
  ///
  /// In it, this message translates to:
  /// **'Larghezza'**
  String get width;

  /// No description provided for @depth.
  ///
  /// In it, this message translates to:
  /// **'Profondità'**
  String get depth;

  /// No description provided for @date.
  ///
  /// In it, this message translates to:
  /// **'Data'**
  String get date;

  /// No description provided for @creationPlace.
  ///
  /// In it, this message translates to:
  /// **'Posto di realizzazione'**
  String get creationPlace;

  /// No description provided for @creationYear.
  ///
  /// In it, this message translates to:
  /// **'Anno di realizzazione'**
  String get creationYear;

  /// No description provided for @notVisible.
  ///
  /// In it, this message translates to:
  /// **'Non visibile'**
  String get notVisible;

  /// No description provided for @visible.
  ///
  /// In it, this message translates to:
  /// **'Visibile'**
  String get visible;

  /// No description provided for @costInEur.
  ///
  /// In it, this message translates to:
  /// **'Prezzo in euro'**
  String get costInEur;

  /// No description provided for @select.
  ///
  /// In it, this message translates to:
  /// **'Seleziona'**
  String get select;

  /// No description provided for @imageSelect.
  ///
  /// In it, this message translates to:
  /// **'Seleziona immagine'**
  String get imageSelect;

  /// No description provided for @rangeSelect.
  ///
  /// In it, this message translates to:
  /// **'Seleziona intervallo'**
  String get rangeSelect;

  /// No description provided for @artworkSelect.
  ///
  /// In it, this message translates to:
  /// **'Seleziona opera d\'arte'**
  String get artworkSelect;

  /// No description provided for @imagesNotSet.
  ///
  /// In it, this message translates to:
  /// **'Non ci sono immagini impostate'**
  String get imagesNotSet;

  /// No description provided for @authorNotSet.
  ///
  /// In it, this message translates to:
  /// **'Non è stato impostato un autore'**
  String get authorNotSet;

  /// No description provided for @exhibitionName.
  ///
  /// In it, this message translates to:
  /// **'Nome della mostra'**
  String get exhibitionName;

  /// No description provided for @address.
  ///
  /// In it, this message translates to:
  /// **'Indirizzo'**
  String get address;

  /// No description provided for @showMore.
  ///
  /// In it, this message translates to:
  /// **'Mostra di più'**
  String get showMore;

  /// No description provided for @phoneNumber.
  ///
  /// In it, this message translates to:
  /// **'Numero di telefono'**
  String get phoneNumber;

  /// No description provided for @exhibition.
  ///
  /// In it, this message translates to:
  /// **'Mostra'**
  String get exhibition;

  /// No description provided for @exhibitions.
  ///
  /// In it, this message translates to:
  /// **'Mostre'**
  String get exhibitions;

  /// No description provided for @cost.
  ///
  /// In it, this message translates to:
  /// **'Costo'**
  String get cost;

  /// No description provided for @costInMoney.
  ///
  /// In it, this message translates to:
  /// **'{money, plural, =0{Gratis}other{{money}}}'**
  String costInMoney(num money);

  /// No description provided for @fromToYMMMMEEEEd.
  ///
  /// In it, this message translates to:
  /// **'Da {start} a {end}'**
  String fromToYMMMMEEEEd(DateTime start, DateTime end);

  /// No description provided for @fromToMMMMd.
  ///
  /// In it, this message translates to:
  /// **'{start} - {end}'**
  String fromToMMMMd(DateTime start, DateTime end);

  /// No description provided for @organizedBy.
  ///
  /// In it, this message translates to:
  /// **'Organizzato da {org}'**
  String organizedBy(String org);

  /// No description provided for @selected.
  ///
  /// In it, this message translates to:
  /// **'Selezionati: {number}'**
  String selected(int number);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'it': return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
