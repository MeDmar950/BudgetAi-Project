// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'BudgetAI';

  @override
  String get tagline => 'الإدارة المالية الذكية لمصر';

  @override
  String get currencyEGP => 'ج.م';

  @override
  String get currencySymbol => 'ج.م';

  @override
  String get totalBalance => 'إجمالي الرصيد';

  @override
  String get income => 'دخل';

  @override
  String get expense => 'مصروف';

  @override
  String get transfer => 'تحويل';

  @override
  String get recentTransactions => 'أحدث المعاملات';

  @override
  String get noTransactionsYet => 'لا توجد معاملات بعد';

  @override
  String get accounts => 'الحسابات';

  @override
  String get budgets => 'الميزانيات';

  @override
  String get analytics => 'التحليلات';

  @override
  String get aiAssistant => 'المساعد الذكي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get switchLanguage => 'English';

  @override
  String get currentLanguage => 'العربية';

  @override
  String get ocrDraftNotice =>
      'الفواتير الممسوحة ضوئياً تُحفظ كمسودات حتى تؤكدها بنفسك.';

  @override
  String get aiDisclaimer =>
      'توصيات الذكاء الاصطناعي إرشادية ولا تقوم بتعديل الأرصدة أو المعاملات تلقائياً.';
}
