import 'package:flutter/material.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback onToggleLanguage;
  final Locale currentLocale;

  const SettingsScreen({
    super.key,
    required this.onToggleLanguage,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabic = currentLocale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Card(
            color: AppColors.surfaceCard,
            child: ListTile(
              leading: const Icon(Icons.language, color: AppColors.primary),
              title: Text(l10n.currentLanguage),
              subtitle: Text(isArabic ? 'العربية (مصر)' : 'English (US)'),
              trailing: ElevatedButton(
                onPressed: onToggleLanguage,
                child: Text(l10n.switchLanguage),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            color: AppColors.surfaceCard,
            child: ListTile(
              leading: const Icon(Icons.security, color: AppColors.primary),
              title: const Text('Architecture & Security'),
              subtitle: const Text(
                'Row-Level Security, Money Invariants & Assistive AI.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
