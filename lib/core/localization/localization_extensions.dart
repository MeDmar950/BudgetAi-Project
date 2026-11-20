import 'package:flutter/widgets.dart';

import '../money/currency.dart';
import '../money/money.dart';
import 'egyptian_currency_formatter.dart';
import 'egyptian_date_formatter.dart';
import 'egyptian_number_formatter.dart';

/// Extension methods on [DateTime] for easy Egyptian localization.
extension EgyptianDateTimeLocalizationExtension on DateTime {
  /// Formats date according to Egyptian style (e.g. "20 نوفمبر 2026").
  String toEgyptianDate({
    String locale = 'ar',
    EgyptianDateStyle style = EgyptianDateStyle.medium,
    bool useEasternDigits = false,
  }) {
    return EgyptianDateFormatter.formatDate(
      this,
      locale: locale,
      style: style,
      useEasternDigits: useEasternDigits,
    );
  }

  /// Formats time in 12-hour Egyptian format (e.g. "04:30 م").
  String toEgyptianTime({
    String locale = 'ar',
    bool use24Hour = false,
    bool useEasternDigits = false,
  }) {
    return EgyptianDateFormatter.formatTime(
      this,
      locale: locale,
      use24Hour: use24Hour,
      useEasternDigits: useEasternDigits,
    );
  }

  /// Formats date and time together (e.g. "20 نوفمبر 2026، 04:30 م").
  String toEgyptianDateTime({
    String locale = 'ar',
    EgyptianDateStyle dateStyle = EgyptianDateStyle.medium,
    bool use24Hour = false,
    bool useEasternDigits = false,
  }) {
    return EgyptianDateFormatter.formatDateTime(
      this,
      locale: locale,
      dateStyle: dateStyle,
      use24Hour: use24Hour,
      useEasternDigits: useEasternDigits,
    );
  }

  /// Formats relative time (e.g. "الآن", "منذ ساعتين", "أمس").
  String toEgyptianRelative({
    DateTime? relativeTo,
    String locale = 'ar',
    bool useEasternDigits = false,
  }) {
    return EgyptianDateFormatter.formatRelative(
      this,
      relativeTo: relativeTo,
      locale: locale,
      useEasternDigits: useEasternDigits,
    );
  }
}

/// Extension methods on [Money] for Egyptian currency formatting.
extension EgyptianMoneyLocalizationExtension on Money {
  /// Formats money in Egyptian Pound (e.g. "1,250.50 ج.م").
  String formatEgyptian({
    String locale = 'ar',
    bool showSymbol = true,
    bool useEasternDigits = false,
    bool showSign = false,
    bool useGrouping = true,
    EgyptianCurrencyFormatStyle style = EgyptianCurrencyFormatStyle.standard,
  }) {
    return EgyptianCurrencyFormatter.format(
      this,
      locale: locale,
      showSymbol: showSymbol,
      useEasternDigits: useEasternDigits,
      showSign: showSign,
      useGrouping: useGrouping,
      style: style,
    );
  }

  /// Formats large money amount in compact notation (e.g. "1.5 ألف ج.م").
  String formatCompact({
    String locale = 'ar',
    bool showSymbol = true,
    bool useEasternDigits = false,
  }) {
    return EgyptianCurrencyFormatter.formatCompact(
      this,
      locale: locale,
      showSymbol: showSymbol,
      useEasternDigits: useEasternDigits,
    );
  }

  /// Formats money with explicit sign (+ / -), ideal for income/expense ledgers.
  String formatSigned({
    String locale = 'ar',
    bool showSymbol = true,
    bool useEasternDigits = false,
  }) {
    return EgyptianCurrencyFormatter.format(
      this,
      locale: locale,
      showSymbol: showSymbol,
      useEasternDigits: useEasternDigits,
      showSign: true,
    );
  }
}

/// Extension on [String] for digit conversion and currency parsing.
extension EgyptianStringLocalizationExtension on String {
  /// Replaces Western digits with Eastern Arabic digits (٠-٩).
  String toEasternArabicDigits() =>
      EgyptianNumberFormatter.toEasternArabicDigits(this);

  /// Replaces Eastern Arabic digits with Western digits (0-9).
  String toWesternArabicDigits() =>
      EgyptianNumberFormatter.toWesternArabicDigits(this);

  /// Parses text as [Money], handling Arabic digits and symbols.
  Money parseAsMoney([Currency currency = Currency.egp]) =>
      EgyptianCurrencyFormatter.parseInput(this, currency);

  /// Safely attempts to parse text as [Money], returning null on failure.
  Money? tryParseAsMoney([Currency currency = Currency.egp]) =>
      EgyptianCurrencyFormatter.tryParseInput(this, currency);
}

/// Extension on [BuildContext] to format directly with active locale.
extension EgyptianContextLocalizationExtension on BuildContext {
  /// Current locale language code (e.g., 'ar' or 'en').
  String get currentLanguageCode {
    return Localizations.localeOf(this).languageCode;
  }

  /// Whether current context is rendered in Arabic.
  bool get isArabic => currentLanguageCode == 'ar';

  /// Formats money according to the current [BuildContext] locale.
  String formatMoney(
    Money money, {
    bool showSymbol = true,
    bool useEasternDigits = false,
    bool showSign = false,
    EgyptianCurrencyFormatStyle style = EgyptianCurrencyFormatStyle.standard,
  }) {
    return EgyptianCurrencyFormatter.format(
      money,
      locale: currentLanguageCode,
      showSymbol: showSymbol,
      useEasternDigits: useEasternDigits,
      showSign: showSign,
      style: style,
    );
  }

  /// Formats date according to the current [BuildContext] locale.
  String formatDate(
    DateTime date, {
    EgyptianDateStyle style = EgyptianDateStyle.medium,
    bool useEasternDigits = false,
  }) {
    return EgyptianDateFormatter.formatDate(
      date,
      locale: currentLanguageCode,
      style: style,
      useEasternDigits: useEasternDigits,
    );
  }

  /// Formats relative date according to current [BuildContext] locale.
  String formatRelativeDate(
    DateTime date, {
    DateTime? relativeTo,
    bool useEasternDigits = false,
  }) {
    return EgyptianDateFormatter.formatRelative(
      date,
      relativeTo: relativeTo,
      locale: currentLanguageCode,
      useEasternDigits: useEasternDigits,
    );
  }

  /// Formats time according to current [BuildContext] locale.
  String formatTime(
    DateTime time, {
    bool use24Hour = false,
    bool useEasternDigits = false,
  }) {
    return EgyptianDateFormatter.formatTime(
      time,
      locale: currentLanguageCode,
      use24Hour: use24Hour,
      useEasternDigits: useEasternDigits,
    );
  }
}
