import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

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
    Locale('pt')
  ];

  /// Main title in the hero section
  ///
  /// In en, this message translates to:
  /// **'Each Nomirro can change your next date.'**
  String get heroTitle;

  /// Subtitle in the hero section
  ///
  /// In en, this message translates to:
  /// **'Discover real-life dates, have fun and connect with people who shine like you. Your next crush is here.'**
  String get heroSubtitle;

  /// CTA button text in hero
  ///
  /// In en, this message translates to:
  /// **'Download app'**
  String get heroCta;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Nomirro'**
  String get aboutTitle;

  /// No description provided for @aboutParagraph1.
  ///
  /// In en, this message translates to:
  /// **'Nomirro is the new generation of dating apps — where connections happen in a light, fun and genuine way.'**
  String get aboutParagraph1;

  /// No description provided for @aboutParagraph2.
  ///
  /// In en, this message translates to:
  /// **'Inspired by real-life dates and authentic stories, Nomirro turns a simple match into moments that truly shine.'**
  String get aboutParagraph2;

  /// No description provided for @aboutItem1Title.
  ///
  /// In en, this message translates to:
  /// **'Real dates, no drama'**
  String get aboutItem1Title;

  /// No description provided for @aboutItem1Body.
  ///
  /// In en, this message translates to:
  /// **'Meet real people with honest intentions. In Nomirro, love happens naturally — without pressure, without judgment, in your own way.'**
  String get aboutItem1Body;

  /// No description provided for @aboutItem2Title.
  ///
  /// In en, this message translates to:
  /// **'Find someone near you'**
  String get aboutItem2Title;

  /// No description provided for @aboutItem2Body.
  ///
  /// In en, this message translates to:
  /// **'Fall in love with someone in your city, your neighbourhood or even on the other side of the world. With Nomirro, distance becomes an opportunity.'**
  String get aboutItem2Body;

  /// No description provided for @aboutItem3Title.
  ///
  /// In en, this message translates to:
  /// **'Talk by video or chat'**
  String get aboutItem3Title;

  /// No description provided for @aboutItem3Body.
  ///
  /// In en, this message translates to:
  /// **'Create real bonds with our modern and safe chat — with or without camera. See, smile and talk face to face with those who make your heart race.'**
  String get aboutItem3Body;

  /// No description provided for @aboutItem4Title.
  ///
  /// In en, this message translates to:
  /// **'Balance and diversity'**
  String get aboutItem4Title;

  /// No description provided for @aboutItem4Body.
  ///
  /// In en, this message translates to:
  /// **'Nomirro is a space for everyone — open, inclusive and full of good vibes. Here, every connection is unique and respected.'**
  String get aboutItem4Body;

  /// No description provided for @aboutItem5Title.
  ///
  /// In en, this message translates to:
  /// **'Where connections shine'**
  String get aboutItem5Title;

  /// No description provided for @aboutItem5Body.
  ///
  /// In en, this message translates to:
  /// **'More than a dating app, Nomirro is a place to be part of something special. Stories start with a click — and continue with sparkles in the eyes.'**
  String get aboutItem5Body;

  /// No description provided for @aboutPremiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Nomirro Premium'**
  String get aboutPremiumTitle;

  /// No description provided for @aboutPremiumBody.
  ///
  /// In en, this message translates to:
  /// **'Unlimited messages, see who liked you and get highlighted in searches. Daily, Weekly and Monthly plans.'**
  String get aboutPremiumBody;

  /// No description provided for @navAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navAbout;

  /// No description provided for @navHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get navHowItWorks;

  /// No description provided for @navFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get navFeatures;

  /// No description provided for @navLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get navLogin;

  /// No description provided for @navSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get navSignUp;

  /// No description provided for @howTitle.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howTitle;

  /// No description provided for @howSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Getting started is easy. In just three steps you’ll be ready to find your next connection.'**
  String get howSubtitle;

  /// No description provided for @howStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Create your profile'**
  String get howStep1Title;

  /// No description provided for @howStep1Body.
  ///
  /// In en, this message translates to:
  /// **'Show your personality. Add your best photos and tell a bit about yourself.'**
  String get howStep1Body;

  /// No description provided for @howStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Swipe and match'**
  String get howStep2Title;

  /// No description provided for @howStep2Body.
  ///
  /// In en, this message translates to:
  /// **'Browse profiles and find interesting people. A swipe to the right can be the start of something new.'**
  String get howStep2Body;

  /// No description provided for @howStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Start the conversation'**
  String get howStep3Title;

  /// No description provided for @howStep3Body.
  ///
  /// In en, this message translates to:
  /// **'Got a match? Don’t wait! Send a message and start building a real connection.'**
  String get howStep3Body;

  /// No description provided for @featuresTitle.
  ///
  /// In en, this message translates to:
  /// **'Connections that happen'**
  String get featuresTitle;

  /// No description provided for @featuresSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Nomirro was designed to be intuitive, safe and focused on your authenticity.'**
  String get featuresSubtitle;

  /// No description provided for @feature1Title.
  ///
  /// In en, this message translates to:
  /// **'Instant chat'**
  String get feature1Title;

  /// No description provided for @feature1Body.
  ///
  /// In en, this message translates to:
  /// **'Don’t wait. Talk in real time and spark connections with text, audio and video messages.'**
  String get feature1Body;

  /// No description provided for @feature2Title.
  ///
  /// In en, this message translates to:
  /// **'Authentic profiles'**
  String get feature2Title;

  /// No description provided for @feature2Body.
  ///
  /// In en, this message translates to:
  /// **'Photo verification and detailed interest filters to help you find exactly what you’re looking for.'**
  String get feature2Body;

  /// No description provided for @feature3Title.
  ///
  /// In en, this message translates to:
  /// **'Safety first'**
  String get feature3Title;

  /// No description provided for @feature3Body.
  ///
  /// In en, this message translates to:
  /// **'Advanced reporting tools and 24/7 moderation to keep your experience safe and fun.'**
  String get feature3Body;

  /// No description provided for @faqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faqTitle;

  /// No description provided for @faqQ1Title.
  ///
  /// In en, this message translates to:
  /// **'Why didn’t I receive the e-mail with my ID and password?'**
  String get faqQ1Title;

  /// No description provided for @faqQ1Body.
  ///
  /// In en, this message translates to:
  /// **'If you do not receive the registration e-mail within 10 minutes, check your spam or junk folder, as some providers may wrongly mark our messages.\nIf you still can’t find it, try using another e-mail address (for example: Gmail, Yahoo, Outlook, etc.).'**
  String get faqQ1Body;

  /// No description provided for @faqQ2Title.
  ///
  /// In en, this message translates to:
  /// **'I forgot my password. How can I reset it?'**
  String get faqQ2Title;

  /// No description provided for @faqQ2Body.
  ///
  /// In en, this message translates to:
  /// **'Go to: https://twynk.app/password\nEnter the e-mail used for registration and click on ‘Reset my password’.\nYou will receive a link to create a new password.'**
  String get faqQ2Body;

  /// No description provided for @faqQ3Title.
  ///
  /// In en, this message translates to:
  /// **'How long does it take for my photos to be approved? Why can’t I send a photo?'**
  String get faqQ3Title;

  /// No description provided for @faqQ3Body.
  ///
  /// In en, this message translates to:
  /// **'Approval may take a few hours, depending on the volume of uploads.\nIf you are having trouble sending photos, check:\n\nPossible causes and solutions:\n- Unsupported format: use only JPEG or PNG.\n- Storage permissions (Android):\nGo to Settings → Apps → [Your browser or Nomirro app] → Permissions → Storage → Enable.\n- Outdated browser or app:\nUpdate Nomirro or try accessing it on another device.'**
  String get faqQ3Body;

  /// No description provided for @faqQ4Title.
  ///
  /// In en, this message translates to:
  /// **'How do I enable or disable e-mail notifications?'**
  String get faqQ4Title;

  /// No description provided for @faqQ4Body.
  ///
  /// In en, this message translates to:
  /// **'Go to your profile → Settings → Notifications → choose your preferences to receive (or not) e-mails about new messages, likes and connections.'**
  String get faqQ4Body;

  /// No description provided for @faqQ5Title.
  ///
  /// In en, this message translates to:
  /// **'How can I delete my profile? I deleted my account by mistake. Can I reactivate it?'**
  String get faqQ5Title;

  /// No description provided for @faqQ5Body.
  ///
  /// In en, this message translates to:
  /// **'To delete your profile, go to Settings → Account → Delete profile and follow the instructions.\nIf you deleted it by mistake, contact support within 7 days at: suporte@twynk.app — after this period, the account is permanently removed.'**
  String get faqQ5Body;

  /// No description provided for @faqQ6Title.
  ///
  /// In en, this message translates to:
  /// **'Can I send my e-mail or phone number in messages?'**
  String get faqQ6Title;

  /// No description provided for @faqQ6Body.
  ///
  /// In en, this message translates to:
  /// **'You can, but Nomirro recommends that you only share personal information after you have built trust with the other person.\nYour safety and privacy come first.'**
  String get faqQ6Body;

  /// No description provided for @faqQ7Title.
  ///
  /// In en, this message translates to:
  /// **'Is Nomirro free?'**
  String get faqQ7Title;

  /// No description provided for @faqQ7Body.
  ///
  /// In en, this message translates to:
  /// **'Yes! Nomirro can be used for free to create an account, chat and meet new people.\nWe also offer Nomirro Premium, with extra features like more visibility, unlimited requests and highlighted profile — but the basic usage will always remain free.'**
  String get faqQ7Body;

  /// No description provided for @faqQ8Title.
  ///
  /// In en, this message translates to:
  /// **'Any other questions?'**
  String get faqQ8Title;

  /// No description provided for @faqQ8Body.
  ///
  /// In en, this message translates to:
  /// **'Contact Nomirro Support by e-mail: suporte@twynk.app or send a message via the Help menu inside the app.'**
  String get faqQ8Body;

  /// No description provided for @ctaTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to Shine?'**
  String get ctaTitle;

  /// No description provided for @ctaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Thousands of people are waiting to connect. Join the Nomirro community today!'**
  String get ctaSubtitle;

  /// No description provided for @ctaAppStore.
  ///
  /// In en, this message translates to:
  /// **'App Store'**
  String get ctaAppStore;

  /// No description provided for @ctaPlayStore.
  ///
  /// In en, this message translates to:
  /// **'Play Store'**
  String get ctaPlayStore;

  /// No description provided for @footerTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get footerTerms;

  /// No description provided for @footerPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get footerPrivacy;

  /// No description provided for @footerCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2025 Nomirro. All rights reserved.'**
  String get footerCopyright;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
