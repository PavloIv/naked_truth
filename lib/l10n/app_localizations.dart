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

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

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

  /// No description provided for @sendFriendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get sendFriendRequest;

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

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @friend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get friend;

  /// No description provided for @signOutTakingTooLong.
  ///
  /// In en, this message translates to:
  /// **'Signing out is taking too long. Please try again.'**
  String get signOutTakingTooLong;

  /// No description provided for @signOutFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to sign out'**
  String get signOutFailed;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @notGenerated.
  ///
  /// In en, this message translates to:
  /// **'Not generated'**
  String get notGenerated;

  /// No description provided for @mainInfo.
  ///
  /// In en, this message translates to:
  /// **'Main information'**
  String get mainInfo;

  /// No description provided for @friendCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Friend code'**
  String get friendCodeLabel;

  /// No description provided for @registrationDate.
  ///
  /// In en, this message translates to:
  /// **'Registration date'**
  String get registrationDate;

  /// No description provided for @friendStatus.
  ///
  /// In en, this message translates to:
  /// **'Friend status'**
  String get friendStatus;

  /// No description provided for @friendConnected.
  ///
  /// In en, this message translates to:
  /// **'Friend connected'**
  String get friendConnected;

  /// No description provided for @noFriendYet.
  ///
  /// In en, this message translates to:
  /// **'No friend yet'**
  String get noFriendYet;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @signingOut.
  ///
  /// In en, this message translates to:
  /// **'Signing out...'**
  String get signingOut;

  /// No description provided for @signOutAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOutAccount;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @endFriendshipQuestion.
  ///
  /// In en, this message translates to:
  /// **'End friendship?'**
  String get endFriendshipQuestion;

  /// No description provided for @endFriendshipDescription.
  ///
  /// In en, this message translates to:
  /// **'You will no longer be connected as friends. You can add a new friend later.'**
  String get endFriendshipDescription;

  /// No description provided for @endFriendshipAction.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endFriendshipAction;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @distanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceLabel;

  /// No description provided for @friendsSinceLabel.
  ///
  /// In en, this message translates to:
  /// **'Friends since'**
  String get friendsSinceLabel;

  /// No description provided for @openChat.
  ///
  /// In en, this message translates to:
  /// **'Open chat'**
  String get openChat;

  /// No description provided for @changeFriend.
  ///
  /// In en, this message translates to:
  /// **'Change friend'**
  String get changeFriend;

  /// No description provided for @endFriendship.
  ///
  /// In en, this message translates to:
  /// **'End friendship'**
  String get endFriendship;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @codeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get codeCopied;

  /// No description provided for @enterFriendCode.
  ///
  /// In en, this message translates to:
  /// **'Enter your friend\'s code'**
  String get enterFriendCode;

  /// No description provided for @friendCodeExample.
  ///
  /// In en, this message translates to:
  /// **'For example: ABC123'**
  String get friendCodeExample;

  /// No description provided for @adding.
  ///
  /// In en, this message translates to:
  /// **'Adding...'**
  String get adding;

  /// No description provided for @changing.
  ///
  /// In en, this message translates to:
  /// **'Changing...'**
  String get changing;

  /// No description provided for @incomingFriendRequest.
  ///
  /// In en, this message translates to:
  /// **'Incoming request'**
  String get incomingFriendRequest;

  /// No description provided for @outgoingFriendRequest.
  ///
  /// In en, this message translates to:
  /// **'Sent request'**
  String get outgoingFriendRequest;

  /// No description provided for @friendRequestFrom.
  ///
  /// In en, this message translates to:
  /// **'Request from {name}'**
  String friendRequestFrom(Object name);

  /// No description provided for @friendRequestTo.
  ///
  /// In en, this message translates to:
  /// **'Request to {name}'**
  String friendRequestTo(Object name);

  /// No description provided for @acceptFriendRequest.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get acceptFriendRequest;

  /// No description provided for @declineFriendRequest.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get declineFriendRequest;

  /// No description provided for @cancelFriendRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel request'**
  String get cancelFriendRequest;

  /// No description provided for @waitingForFriendConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Friendship will be created only after the other user confirms it.'**
  String get waitingForFriendConfirmation;

  /// No description provided for @pendingRequestBlocksNewOne.
  ///
  /// In en, this message translates to:
  /// **'You can\'t send a new friendship request while another one is active.'**
  String get pendingRequestBlocksNewOne;

  /// No description provided for @friendWillReplaceCurrent.
  ///
  /// In en, this message translates to:
  /// **'After confirmation, a new friendship will be created.'**
  String get friendWillReplaceCurrent;

  /// No description provided for @onlineInBrackets.
  ///
  /// In en, this message translates to:
  /// **'(online)'**
  String get onlineInBrackets;

  /// No description provided for @lastSeenAt.
  ///
  /// In en, this message translates to:
  /// **'(last seen at {hour}:{minute})'**
  String lastSeenAt(Object hour, Object minute);

  /// No description provided for @startConversation.
  ///
  /// In en, this message translates to:
  /// **'Start the conversation'**
  String get startConversation;

  /// No description provided for @enterMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter a message...'**
  String get enterMessage;

  /// No description provided for @noQuestionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No questions available.'**
  String get noQuestionsAvailable;

  /// No description provided for @questionProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String questionProgress(int current, int total);

  /// No description provided for @activatePremium.
  ///
  /// In en, this message translates to:
  /// **'Activate premium'**
  String get activatePremium;

  /// No description provided for @yourPremiumCodeForFriend.
  ///
  /// In en, this message translates to:
  /// **'Your premium code for a friend'**
  String get yourPremiumCodeForFriend;

  /// No description provided for @enterPremiumCode.
  ///
  /// In en, this message translates to:
  /// **'Enter premium code'**
  String get enterPremiumCode;

  /// No description provided for @premiumCodeExample.
  ///
  /// In en, this message translates to:
  /// **'For example: PREM123'**
  String get premiumCodeExample;

  /// No description provided for @applying.
  ///
  /// In en, this message translates to:
  /// **'Applying...'**
  String get applying;

  /// No description provided for @premiumActive.
  ///
  /// In en, this message translates to:
  /// **'✅ Premium is active'**
  String get premiumActive;

  /// No description provided for @premiumInactive.
  ///
  /// In en, this message translates to:
  /// **'❌ Premium is not active'**
  String get premiumInactive;

  /// No description provided for @premiumValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until: {date}'**
  String premiumValidUntil(Object date);

  /// No description provided for @selectYear.
  ///
  /// In en, this message translates to:
  /// **'Select year'**
  String get selectYear;

  /// No description provided for @selectYearAndMonth.
  ///
  /// In en, this message translates to:
  /// **'Select year and month'**
  String get selectYearAndMonth;

  /// No description provided for @selectYearMonthAndDay.
  ///
  /// In en, this message translates to:
  /// **'Select year, month, and day'**
  String get selectYearMonthAndDay;
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
