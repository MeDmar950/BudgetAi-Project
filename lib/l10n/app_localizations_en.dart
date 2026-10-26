// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BudgetAI';

  @override
  String get tagline => 'Smart Financial Management for Egypt';

  @override
  String get currencyEGP => 'EGP';

  @override
  String get currencySymbol => 'EGP';

  @override
  String get totalBalance => 'Total Balance';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get transfer => 'Transfer';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get noTransactionsYet => 'No transactions yet';

  @override
  String get accounts => 'Accounts';

  @override
  String get budgets => 'Budgets';

  @override
  String get analytics => 'Analytics';

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get settings => 'Settings';

  @override
  String get switchLanguage => 'العربية';

  @override
  String get currentLanguage => 'English';

  @override
  String get ocrDraftNotice =>
      'Scanned receipts are saved as drafts until confirmed by you.';

  @override
  String get aiDisclaimer =>
      'AI insights are assistive and never modify balances or records automatically.';
}
