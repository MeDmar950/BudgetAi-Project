import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  // Foundation
  String get appTitle;
  String get tagline;
  String get currencyEGP;
  String get currencySymbol;
  String get piastre;
  String get piastres;
  String get totalBalance;
  String get income;
  String get expense;
  String get transfer;
  String get transactions;
  String get recentTransactions;
  String get noTransactionsYet;
  String get accounts;
  String get budgets;
  String get analytics;
  String get aiAssistant;
  String get settings;
  String get switchLanguage;
  String get currentLanguage;
  String get ocrDraftNotice;
  String get aiDisclaimer;

  // Common Actions
  String get save;
  String get cancel;
  String get confirm;
  String get delete;
  String get edit;
  String get add;
  String get back;
  String get next;
  String get submit;
  String get done;
  String get close;
  String get retry;
  String get search;
  String get filter;
  String get apply;
  String get reset;
  String get continueButton;

  // Auth & Onboarding
  String get login;
  String get register;
  String get createAccount;
  String get welcomeBack;
  String get welcomeToApp;
  String get email;
  String get emailHint;
  String get password;
  String get passwordHint;
  String get confirmPassword;
  String get confirmPasswordHint;
  String get forgotPassword;
  String get dontHaveAccount;
  String get alreadyHaveAccount;
  String get guestContinue;
  String get logout;
  String get logoutConfirmation;

  // Validation
  String get fieldRequired;
  String get invalidEmail;
  String get invalidPassword;
  String get passwordsDoNotMatch;
  String get invalidAmount;
  String get amountMustBePositive;

  // Accounts
  String get addAccount;
  String get editAccount;
  String get deleteAccount;
  String get accountName;
  String get accountType;
  String get initialBalance;
  String get currentBalance;
  String get bankAccount;
  String get cashWallet;
  String get mobileWallet;
  String get creditCard;
  String get savingsAccount;
  String get noAccountsYet;
  String get selectAccount;
  String get fromAccount;
  String get toAccount;

  // Transactions
  String get addTransaction;
  String get editTransaction;
  String get deleteTransaction;
  String get transactionDetails;
  String get amount;
  String get amountHint;
  String get category;
  String get selectCategory;
  String get date;
  String get time;
  String get note;
  String get noteHint;

  // Categories
  String get categoryFood;
  String get categoryTransportation;
  String get categoryHousing;
  String get categoryShopping;
  String get categoryEntertainment;
  String get categoryHealth;
  String get categoryEducation;
  String get categorySalary;
  String get categoryInvestments;
  String get categoryGroceries;
  String get categoryOther;

  // Budgets
  String get addBudget;
  String get budgetLimit;
  String get spent;
  String get remaining;
  String get overBudget;
  String get monthlyBudget;
  String get noBudgetsYet;

  // Analytics
  String get cashFlow;
  String get netSavings;
  String get spendingByCategory;
  String get monthlyComparison;
  String get thisMonth;
  String get lastMonth;
  String get thisWeek;
  String get allTime;

  // Egyptian Dates & Time
  String get today;
  String get yesterday;
  String get tomorrow;
  String get justNow;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
