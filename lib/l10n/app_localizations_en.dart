// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Naked Truth';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get category => 'Category';

  @override
  String get adult => 'Adult';

  @override
  String get couples => 'Couples';

  @override
  String get friends => 'Friends';

  @override
  String get buttonNext => 'Next';

  @override
  String get buttonStart => 'Start';

  @override
  String get enableLocationTitle => 'Enable Location';

  @override
  String get enableLocationText => 'To see the distance to your friend, please enable location services on your device.';

  @override
  String get openSettingsAction => 'Open Settings';

  @override
  String get locationAccessTitle => 'Location Access';

  @override
  String get locationAccessText => 'To show the distance between you and your friend, the app needs access to your location.';

  @override
  String get okAction => 'OK';

  @override
  String get locationAccessNotGranted => 'Location access not granted — distance feature will be limited.';

  @override
  String get grantLocationAccess => 'Grant location access';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get signIn => 'Sign In';

  @override
  String get signingIn => 'Signing in...';

  @override
  String get welcome => 'Welcome!\'';

  @override
  String get signInToStart => 'Sign in to start.';

  @override
  String get onboardingFirstTitle => 'Question for Every Mood';

  @override
  String get onboardingFirstText => 'Turn any moment into a deeper, more meaningful conversation';

  @override
  String get onboardingSecondTitle => 'Enjoying MustHave Talks?';

  @override
  String get onboardingSecondText => 'If you like what you see, tap ★★★★★ and help other couples find us!';

  @override
  String get onboardingThirdTitle => 'Pick Your Perfect Deck';

  @override
  String get onboardingThirdText => '40 + themed question sets—from cozy nights-in to road-trip laughs';

  @override
  String get onboardingFourthTitle => 'Keep the Spark Alive';

  @override
  String get onboardingFourthText => 'Get a fresh question every day, save favorites, and track your journey together';

  @override
  String get settings => 'Settings';

  @override
  String get accessAllFeatures => 'Access all features';

  @override
  String get upgradeToPremium => 'Upgrade to Premium';

  @override
  String get unlock => 'UNLOCK';

  @override
  String get getPremium => 'Get Premium';

  @override
  String get restorePurchase => 'Restore Purchase';

  @override
  String get addFriend => 'Add friend';

  @override
  String get myFriend => 'My friend';

  @override
  String get usePremiumCode => 'Use premium code';

  @override
  String get other => 'Other';

  @override
  String get rateThisApp => 'Rate this app';

  @override
  String get shareApp => 'Share App';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get purchaseRestored => 'Your purchase has been successfully restored.';

  @override
  String get purchaseRestoreFailed => 'Failed to restore your purchase. Please try again later.';

  @override
  String get account => 'Account';

  @override
  String get friend => 'Friend';

  @override
  String get signOutTakingTooLong => 'Signing out is taking too long. Please try again.';

  @override
  String get signOutFailed => 'Failed to sign out';

  @override
  String get userNotFound => 'User not found';

  @override
  String get user => 'User';

  @override
  String get notGenerated => 'Not generated';

  @override
  String get mainInfo => 'Main information';

  @override
  String get friendCodeLabel => 'Friend code';

  @override
  String get registrationDate => 'Registration date';

  @override
  String get friendStatus => 'Friend status';

  @override
  String get friendConnected => 'Friend connected';

  @override
  String get noFriendYet => 'No friend yet';

  @override
  String get unknown => 'Unknown';

  @override
  String get signingOut => 'Signing out...';

  @override
  String get signOutAccount => 'Sign out';

  @override
  String get cancel => 'Cancel';

  @override
  String get remove => 'Remove';

  @override
  String get endFriendshipQuestion => 'End friendship?';

  @override
  String get endFriendshipDescription => 'You will no longer be connected as friends. You can add a new friend later.';

  @override
  String get endFriendshipAction => 'End';

  @override
  String get noData => 'No data';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get distanceLabel => 'Distance';

  @override
  String get friendsSinceLabel => 'Friends since';

  @override
  String get openChat => 'Open chat';

  @override
  String get changeFriend => 'Change friend';

  @override
  String get endFriendship => 'End friendship';

  @override
  String get copy => 'Copy';

  @override
  String get share => 'Share';

  @override
  String get codeCopied => 'Code copied';

  @override
  String get enterFriendCode => 'Enter your friend\'s code';

  @override
  String get friendCodeExample => 'For example: ABC123';

  @override
  String get adding => 'Adding...';

  @override
  String get changing => 'Changing...';

  @override
  String get onlineInBrackets => '(online)';

  @override
  String lastSeenAt(Object hour, Object minute) {
    return '(last seen at $hour:$minute)';
  }

  @override
  String get startConversation => 'Start the conversation';

  @override
  String get enterMessage => 'Enter a message...';

  @override
  String get noQuestionsAvailable => 'No questions available.';

  @override
  String questionProgress(int current, int total) {
    return '$current of $total';
  }

  @override
  String get activatePremium => 'Activate premium';

  @override
  String get yourPremiumCodeForFriend => 'Your premium code for a friend';

  @override
  String get enterPremiumCode => 'Enter premium code';

  @override
  String get premiumCodeExample => 'For example: PREM123';

  @override
  String get applying => 'Applying...';

  @override
  String get premiumActive => '✅ Premium is active';

  @override
  String get premiumInactive => '❌ Premium is not active';

  @override
  String premiumValidUntil(Object date) {
    return 'Valid until: $date';
  }

  @override
  String get selectYear => 'Select year';

  @override
  String get selectYearAndMonth => 'Select year and month';

  @override
  String get selectYearMonthAndDay => 'Select year, month, and day';
}
