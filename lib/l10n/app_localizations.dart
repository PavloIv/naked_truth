import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('en'),
    Locale('uk')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Naked Truth'**
  String get appName;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @adult.
  ///
  /// In en, this message translates to:
  /// **'Adult'**
  String get adult;

  /// No description provided for @couples.
  ///
  /// In en, this message translates to:
  /// **'Couples'**
  String get couples;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @buttonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get buttonNext;

  /// No description provided for @buttonStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get buttonStart;

  /// No description provided for @enableLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Location'**
  String get enableLocationTitle;

  /// No description provided for @enableLocationText.
  ///
  /// In en, this message translates to:
  /// **'To see the distance to your friend, please enable location services on your device.'**
  String get enableLocationText;

  /// No description provided for @openSettingsAction.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettingsAction;

  /// No description provided for @locationAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Access'**
  String get locationAccessTitle;

  /// No description provided for @locationAccessText.
  ///
  /// In en, this message translates to:
  /// **'To show the distance between you and your friend, the app needs access to your location.'**
  String get locationAccessText;

  /// No description provided for @okAction.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okAction;

  /// No description provided for @locationAccessNotGranted.
  ///
  /// In en, this message translates to:
  /// **'Location access not granted — distance feature will be limited.'**
  String get locationAccessNotGranted;

  /// No description provided for @grantLocationAccess.
  ///
  /// In en, this message translates to:
  /// **'Grant location access'**
  String get grantLocationAccess;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signingIn;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!\''**
  String get welcome;

  /// No description provided for @signInToStart.
  ///
  /// In en, this message translates to:
  /// **'Sign in to start.'**
  String get signInToStart;

  /// No description provided for @onboardingFirstTitle.
  ///
  /// In en, this message translates to:
  /// **'Question for Every Mood'**
  String get onboardingFirstTitle;

  /// No description provided for @onboardingFirstText.
  ///
  /// In en, this message translates to:
  /// **'Turn any moment into a deeper, more meaningful conversation'**
  String get onboardingFirstText;

  /// No description provided for @onboardingSecondTitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoying MustHave Talks?'**
  String get onboardingSecondTitle;

  /// No description provided for @onboardingSecondText.
  ///
  /// In en, this message translates to:
  /// **'If you like what you see, tap ★★★★★ and help other couples find us!'**
  String get onboardingSecondText;

  /// No description provided for @onboardingThirdTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick Your Perfect Deck'**
  String get onboardingThirdTitle;

  /// No description provided for @onboardingThirdText.
  ///
  /// In en, this message translates to:
  /// **'40 + themed question sets—from cozy nights-in to road-trip laughs'**
  String get onboardingThirdText;

  /// No description provided for @onboardingFourthTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the Spark Alive'**
  String get onboardingFourthTitle;

  /// No description provided for @onboardingFourthText.
  ///
  /// In en, this message translates to:
  /// **'Get a fresh question every day, save favorites, and track your journey together'**
  String get onboardingFourthText;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @accessAllFeatures.
  ///
  /// In en, this message translates to:
  /// **'Access all features'**
  String get accessAllFeatures;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'UNLOCK'**
  String get unlock;

  /// No description provided for @getPremium.
  ///
  /// In en, this message translates to:
  /// **'Get Premium'**
  String get getPremium;

  /// No description provided for @restorePurchase.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchase'**
  String get restorePurchase;

  /// No description provided for @addFriend.
  ///
  /// In en, this message translates to:
  /// **'Add friend'**
  String get addFriend;

  /// No description provided for @myFriend.
  ///
  /// In en, this message translates to:
  /// **'My friend'**
  String get myFriend;

  /// No description provided for @usePremiumCode.
  ///
  /// In en, this message translates to:
  /// **'Use premium code'**
  String get usePremiumCode;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @rateThisApp.
  ///
  /// In en, this message translates to:
  /// **'Rate this app'**
  String get rateThisApp;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @purchaseRestored.
  ///
  /// In en, this message translates to:
  /// **'Your purchase has been successfully restored.'**
  String get purchaseRestored;

  /// No description provided for @purchaseRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to restore your purchase. Please try again later.'**
  String get purchaseRestoreFailed;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'uk': return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
