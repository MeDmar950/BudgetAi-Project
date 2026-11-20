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
  String get piastre => 'قرش';

  @override
  String get piastres => 'قروش';

  @override
  String get totalBalance => 'إجمالي الرصيد';

  @override
  String get income => 'دخل';

  @override
  String get expense => 'مصروف';

  @override
  String get transfer => 'تحويل';

  @override
  String get transactions => 'المعاملات';

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

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get add => 'إضافة';

  @override
  String get back => 'رجوع';

  @override
  String get next => 'التالي';

  @override
  String get submit => 'إرسال';

  @override
  String get done => 'تم';

  @override
  String get close => 'إغلاق';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get search => 'بحث';

  @override
  String get filter => 'تصفية';

  @override
  String get apply => 'تطبيق';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get continueButton => 'متابعة';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get createAccount => 'إنشاء حساب جديد';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get welcomeToApp => 'أهلاً بك في BudgetAI';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordHint => 'أعد إدخال كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ أنشئ حساباً';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ تسجيل الدخول';

  @override
  String get guestContinue => 'المتابعة كضيف (تجربة)';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirmation => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get invalidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get invalidPassword => 'يجب ألا تقل كلمة المرور عن 6 أحرف';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get invalidAmount => 'يرجى إدخال مبلغ صحيح';

  @override
  String get amountMustBePositive => 'يجب أن يكون المبلغ أكبر من صفر';

  @override
  String get addAccount => 'إضافة حساب';

  @override
  String get editAccount => 'تعديل الحساب';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get accountName => 'اسم الحساب';

  @override
  String get accountType => 'نوع الحساب';

  @override
  String get initialBalance => 'الرصيد الافتتاحي';

  @override
  String get currentBalance => 'الرصيد الحالي';

  @override
  String get bankAccount => 'حساب بنكي';

  @override
  String get cashWallet => 'محفظة كاش';

  @override
  String get mobileWallet => 'محفظة إلكترونية (فودافون كاش، إلخ)';

  @override
  String get creditCard => 'بطاقة ائتمان';

  @override
  String get savingsAccount => 'حساب توفير';

  @override
  String get noAccountsYet => 'لم تتم إضافة أي حسابات بعد';

  @override
  String get selectAccount => 'اختر الحساب';

  @override
  String get fromAccount => 'من حساب';

  @override
  String get toAccount => 'إلى حساب';

  @override
  String get addTransaction => 'إضافة معاملة';

  @override
  String get editTransaction => 'تعديل المعاملة';

  @override
  String get deleteTransaction => 'حذف المعاملة';

  @override
  String get transactionDetails => 'تفاصيل المعاملة';

  @override
  String get amount => 'المبلغ';

  @override
  String get amountHint => '0.00';

  @override
  String get category => 'الفئة';

  @override
  String get selectCategory => 'اختر الفئة';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get note => 'ملاحظات';

  @override
  String get noteHint => 'أضف ملاحظة اختيارية';

  @override
  String get categoryFood => 'طعام ومشروبات';

  @override
  String get categoryTransportation => 'مواصلات وانتقالات';

  @override
  String get categoryHousing => 'سكن وفواتير';

  @override
  String get categoryShopping => 'تسوق ومشتريات';

  @override
  String get categoryEntertainment => 'ترفيه وخروج';

  @override
  String get categoryHealth => 'صحة وعلاج';

  @override
  String get categoryEducation => 'تعليم وتطوير';

  @override
  String get categorySalary => 'مرتب';

  @override
  String get categoryInvestments => 'استثمارات';

  @override
  String get categoryGroceries => 'طلبات البيت وسوبرماركت';

  @override
  String get categoryOther => 'أخرى';

  @override
  String get addBudget => 'إضافة ميزانية';

  @override
  String get budgetLimit => 'الحد الأقصى للميزانية';

  @override
  String get spent => 'المصروف';

  @override
  String get remaining => 'المتبقي';

  @override
  String get overBudget => 'تجاوزت الميزانية';

  @override
  String get monthlyBudget => 'ميزانية شهرية';

  @override
  String get noBudgetsYet => 'لا توجد ميزانيات محددة بعد';

  @override
  String get cashFlow => 'التدفق النقدي';

  @override
  String get netSavings => 'صافي المدخرات';

  @override
  String get spendingByCategory => 'المصروفات حسب الفئة';

  @override
  String get monthlyComparison => 'مقارنة الشهور';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get lastMonth => 'الشهر الماضي';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get allTime => 'كل الأوقات';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get tomorrow => 'غداً';

  @override
  String get justNow => 'الآن';
}
