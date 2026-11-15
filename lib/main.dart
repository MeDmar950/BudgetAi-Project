import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_ai/l10n/app_localizations.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BudgetAiApp());
}

class BudgetAiApp extends StatefulWidget {
  const BudgetAiApp({super.key});

  @override
  State<BudgetAiApp> createState() => _BudgetAiAppState();
}

class _BudgetAiAppState extends State<BudgetAiApp> {
  Locale _locale = const Locale('ar'); // Default to Egypt-first Arabic (RTL)
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _initRouter();
  }

  void _initRouter() {
    _router = createAppRouter(
      onToggleLanguage: _toggleLocale,
      currentLocale: _locale,
    );
  }

  void _toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'ar'
          ? const Locale('en')
          : const Locale('ar');
      _initRouter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BudgetAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: _router,
    );
  }
}
