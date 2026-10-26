import 'package:flutter/widgets.dart';
import 'package:budget_ai/l10n/app_localizations.dart';

extension LocalizationContextExtension on BuildContext {
  AppLocalizations get l10n {
    final localizations = AppLocalizations.of(this);
    assert(
      localizations != null,
      'No AppLocalizations found in BuildContext. Ensure localizationsDelegates are configured.',
    );
    return localizations!;
  }
}
