import 'package:flutter/material.dart';
import 'package:budget_ai/l10n/app_localizations.dart';
import 'core/localization/l10n_extension.dart';
import 'core/money/money.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_spacing.dart';
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

  void _toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'ar'
          ? const Locale('en')
          : const Locale('ar');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BudgetAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: BudgetAiShellScreen(
        onToggleLanguage: _toggleLocale,
        currentLocale: _locale,
      ),
    );
  }
}

class BudgetAiShellScreen extends StatelessWidget {
  final VoidCallback onToggleLanguage;
  final Locale currentLocale;

  const BudgetAiShellScreen({
    super.key,
    required this.onToggleLanguage,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabic = currentLocale.languageCode == 'ar';

    // Demo balance formatted with safe integer-minor Money utility (e.g. 24,500.50 EGP)
    final demoBalance = Money.fromMinorUnits(2450050);
    final demoIncome = Money.fromMinorUnits(3000000);
    final demoExpense = Money.fromMinorUnits(549950);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              l10n.appTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: AppSpacing.md),
            child: ActionChip(
              avatar: const Icon(
                Icons.language,
                size: 16,
                color: AppColors.textPrimary,
              ),
              label: Text(
                l10n.switchLanguage,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: AppColors.surfaceElevated,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              onPressed: onToggleLanguage,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome card
              Card(
                color: AppColors.surfaceCard,
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.totalBalance,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        demoBalance.format(isArabic ? 'ar' : 'en'),
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Divider(color: AppColors.borderSubtle),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: _StatMiniCard(
                              label: l10n.income,
                              amount: demoIncome.format(isArabic ? 'ar' : 'en'),
                              color: AppColors.income,
                              icon: Icons.arrow_downward_rounded,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: _StatMiniCard(
                              label: l10n.expense,
                              amount: demoExpense.format(
                                isArabic ? 'ar' : 'en',
                              ),
                              color: AppColors.expense,
                              icon: Icons.arrow_upward_rounded,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Architectural Guardrail Banners
              _GuardrailBanner(
                icon: Icons.document_scanner_outlined,
                title: 'OCR Draft Isolation',
                description: l10n.ocrDraftNotice,
                color: AppColors.warning,
              ),
              const SizedBox(height: AppSpacing.sm),
              _GuardrailBanner(
                icon: Icons.psychology_outlined,
                title: 'AI Assistive Guardrail',
                description: l10n.aiDisclaimer,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Section: Foundation Shell Note
              Card(
                color: AppColors.surface,
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.layers_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'BudgetAI Foundation Shell',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'This shell establishes the RTL/LTR localization pipeline, dark design tokens, and exact integer minor-unit financial rules. Feature screens await Figma frame alignment per team sprint plan.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatMiniCard extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  final IconData icon;

  const _StatMiniCard({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _GuardrailBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _GuardrailBanner({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
