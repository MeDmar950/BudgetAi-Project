/// Named route path constants for BudgetAI.
abstract final class AppRoutes {
  // Shell Tab Routes
  static const String accounts = '/';
  static const String transactions = '/transactions';
  static const String budgets = '/budgets';
  static const String analytics = '/analytics';
  static const String settings = '/settings';

  // Auth Top-Level Routes
  static const String login = '/login';
  static const String register = '/register';

  // Modal / Deep Flow Routes
  static const String addTransaction = '/transactions/add';
  static const String ocrScan = '/ocr/scan';
  static const String aiChat = '/ai/chat';
}
