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
  String get piastre => 'Piastre';

  @override
  String get piastres => 'Piastres';

  @override
  String get totalBalance => 'Total Balance';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get transfer => 'Transfer';

  @override
  String get transactions => 'Transactions';

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

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get submit => 'Submit';

  @override
  String get done => 'Done';

  @override
  String get close => 'Close';

  @override
  String get retry => 'Retry';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get apply => 'Apply';

  @override
  String get reset => 'Reset';

  @override
  String get continueButton => 'Continue';

  @override
  String get login => 'Log In';

  @override
  String get register => 'Register';

  @override
  String get createAccount => 'Create Account';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get welcomeToApp => 'Welcome to BudgetAI';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Re-enter your password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Register';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign In';

  @override
  String get guestContinue => 'Continue to App (Guest / Demo)';

  @override
  String get logout => 'Log Out';

  @override
  String get logoutConfirmation => 'Are you sure you want to log out?';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get invalidPassword => 'Password must be at least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get invalidAmount => 'Please enter a valid amount';

  @override
  String get amountMustBePositive => 'Amount must be greater than zero';

  @override
  String get addAccount => 'Add Account';

  @override
  String get editAccount => 'Edit Account';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get accountName => 'Account Name';

  @override
  String get accountType => 'Account Type';

  @override
  String get initialBalance => 'Initial Balance';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get bankAccount => 'Bank Account';

  @override
  String get cashWallet => 'Cash Wallet';

  @override
  String get mobileWallet => 'Mobile Wallet (Vodafone Cash, etc.)';

  @override
  String get creditCard => 'Credit Card';

  @override
  String get savingsAccount => 'Savings Account';

  @override
  String get noAccountsYet => 'No accounts added yet';

  @override
  String get selectAccount => 'Select Account';

  @override
  String get fromAccount => 'From Account';

  @override
  String get toAccount => 'To Account';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get deleteTransaction => 'Delete Transaction';

  @override
  String get transactionDetails => 'Transaction Details';

  @override
  String get amount => 'Amount';

  @override
  String get amountHint => '0.00';

  @override
  String get category => 'Category';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get note => 'Note';

  @override
  String get noteHint => 'Add an optional note';

  @override
  String get categoryFood => 'Food & Dining';

  @override
  String get categoryTransportation => 'Transportation';

  @override
  String get categoryHousing => 'Housing & Utilities';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categoryHealth => 'Health & Medical';

  @override
  String get categoryEducation => 'Education';

  @override
  String get categorySalary => 'Salary';

  @override
  String get categoryInvestments => 'Investments';

  @override
  String get categoryGroceries => 'Groceries';

  @override
  String get categoryOther => 'Other';

  @override
  String get addBudget => 'Add Budget';

  @override
  String get budgetLimit => 'Budget Limit';

  @override
  String get spent => 'Spent';

  @override
  String get remaining => 'Remaining';

  @override
  String get overBudget => 'Over Budget';

  @override
  String get monthlyBudget => 'Monthly Budget';

  @override
  String get noBudgetsYet => 'No budgets set yet';

  @override
  String get cashFlow => 'Cash Flow';

  @override
  String get netSavings => 'Net Savings';

  @override
  String get spendingByCategory => 'Spending by Category';

  @override
  String get monthlyComparison => 'Monthly Comparison';

  @override
  String get thisMonth => 'This Month';

  @override
  String get lastMonth => 'Last Month';

  @override
  String get thisWeek => 'This Week';

  @override
  String get allTime => 'All Time';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get justNow => 'Just now';
}
