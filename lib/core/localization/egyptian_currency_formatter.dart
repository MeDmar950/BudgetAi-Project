import '../money/currency.dart';
import '../money/money.dart';
import 'egyptian_number_formatter.dart';

/// Display styling options for Egyptian currency amounts.
enum EgyptianCurrencyFormatStyle {
  /// e.g. "1,250.50 ج.م" or "EGP 1,250.50"
  standard,

  /// e.g. "1,250 ج.م" (drops piastres if they are zero)
  compactZeros,

  /// e.g. "1.5 ألف ج.م" or "1.5K EGP"
  compactScale,
}

/// Helper functions for formatting Egyptian Pound (EGP) and Piastres.
///
/// Strictly maintains financial precision invariants by operating exclusively on
/// integer minor units ([Money.minorUnits]) without ever casting to [double].
final class EgyptianCurrencyFormatter {
  EgyptianCurrencyFormatter._();

  /// Egyptian currency symbol in Arabic
  static const String symbolArabic = 'ج.م';

  /// Egyptian currency code in English
  static const String symbolEnglish = 'EGP';

  /// Egyptian minor unit name in Arabic singular
  static const String piastreArabic = 'قرش';

  /// Egyptian minor unit name in Arabic plural
  static const String piastresArabic = 'قروش';

  /// Formats a [Money] amount according to Egyptian locale conventions.
  ///
  /// In Arabic locale:
  /// - Default: "1,250.50 ج.م"
  /// - With [useEasternDigits]: "١،٢٥٠٫٥٠ ج.م"
  /// - With [showSign]: "+1,250.50 ج.م" or "-1,250.50 ج.م"
  ///
  /// In English locale:
  /// - Default: "EGP 1,250.50"
  static String format(
    Money money, {
    String locale = 'ar',
    bool showSymbol = true,
    bool useEasternDigits = false,
    bool showSign = false,
    bool useGrouping = true,
    EgyptianCurrencyFormatStyle style = EgyptianCurrencyFormatStyle.standard,
  }) {
    if (style == EgyptianCurrencyFormatStyle.compactScale) {
      return formatCompact(
        money,
        locale: locale,
        showSymbol: showSymbol,
        useEasternDigits: useEasternDigits,
      );
    }

    final isArabic = locale.startsWith('ar');
    final isNegative = money.isNegative;
    final isZero = money.isZero;

    final absMinor = money.minorUnits.abs();
    final multiplier = money.currency.minorUnitMultiplier;
    final major = absMinor ~/ multiplier;
    final frac = absMinor % multiplier;

    // Check if we should omit piastres when zero under compactZeros style
    final omitFraction =
        style == EgyptianCurrencyFormatStyle.compactZeros && frac == 0;

    String numberStr;
    if (omitFraction) {
      numberStr = EgyptianNumberFormatter.formatInteger(
        major,
        useGrouping: useGrouping,
        useEasternDigits: useEasternDigits,
      );
    } else {
      numberStr = EgyptianNumberFormatter.formatDecimalParts(
        majorUnits: major,
        minorUnits: frac,
        decimalDigits: money.currency.decimalDigits,
        useGrouping: useGrouping,
        useEasternDigits: useEasternDigits,
      );
    }

    // Determine sign prefix
    String signStr = '';
    if (isNegative) {
      signStr = '-';
    } else if (showSign && !isZero) {
      signStr = '+';
    }

    if (useEasternDigits && signStr.isNotEmpty) {
      // In Arabic text, keep sign attached to the number
      numberStr = '$signStr$numberStr';
    } else if (signStr.isNotEmpty) {
      numberStr = '$signStr$numberStr';
    }

    if (!showSymbol) {
      return numberStr;
    }

    final symbol = isArabic ? symbolArabic : symbolEnglish;
    if (isArabic) {
      // In Arabic, symbol appears after amount: "150.00 ج.م"
      return '$numberStr $symbol';
    } else {
      // In English, symbol appears before amount: "EGP 150.00"
      return '$symbol $numberStr';
    }
  }

  /// Formats large amounts into human-readable compact notation (e.g. 1.5 ألف / 1.5K).
  ///
  /// Completely avoids floating point by working on integer fractions.
  static String formatCompact(
    Money money, {
    String locale = 'ar',
    bool showSymbol = true,
    bool useEasternDigits = false,
  }) {
    final isArabic = locale.startsWith('ar');
    final absMinor = money.minorUnits.abs();
    final major = absMinor ~/ money.currency.minorUnitMultiplier;
    final isNegative = money.isNegative;

    String scaledNumber;
    String unitSuffix = '';

    if (major >= 1000000) {
      // Millions
      final millions = major ~/ 1000000;
      final remainder = (major % 1000000) ~/ 100000; // 1 decimal place
      scaledNumber = remainder == 0 ? '$millions' : '$millions.$remainder';
      unitSuffix = isArabic ? 'مليون' : 'M';
    } else if (major >= 1000) {
      // Thousands
      final thousands = major ~/ 1000;
      final remainder = (major % 1000) ~/ 100; // 1 decimal place
      scaledNumber = remainder == 0 ? '$thousands' : '$thousands.$remainder';
      unitSuffix = isArabic ? 'ألف' : 'K';
    } else {
      final frac = absMinor % money.currency.minorUnitMultiplier;
      scaledNumber = EgyptianNumberFormatter.formatDecimalParts(
        majorUnits: major,
        minorUnits: frac,
        decimalDigits: money.currency.decimalDigits,
        useGrouping: false,
        useEasternDigits: false,
      );
    }

    if (isNegative) {
      scaledNumber = '-$scaledNumber';
    }

    if (useEasternDigits) {
      scaledNumber = EgyptianNumberFormatter.toEasternArabicDigits(scaledNumber)
          .replaceAll('.', '٫');
    }

    final symbol = isArabic ? symbolArabic : symbolEnglish;

    if (unitSuffix.isEmpty) {
      return showSymbol
          ? (isArabic ? '$scaledNumber $symbol' : '$symbol $scaledNumber')
          : scaledNumber;
    }

    if (isArabic) {
      final withUnit = '$scaledNumber $unitSuffix';
      return showSymbol ? '$withUnit $symbol' : withUnit;
    } else {
      final withUnit = '$scaledNumber$unitSuffix';
      return showSymbol ? '$symbol $withUnit' : withUnit;
    }
  }

  /// Formats small piastre amounts directly (e.g. "50 قرش" or "50 Piastres").
  static String formatPiastres(
    int piastres, {
    String locale = 'ar',
    bool useEasternDigits = false,
  }) {
    final isArabic = locale.startsWith('ar');
    final absVal = piastres.abs();
    final formattedNumber = EgyptianNumberFormatter.formatInteger(
      piastres,
      useEasternDigits: useEasternDigits,
    );

    if (isArabic) {
      final unit = (absVal >= 3 && absVal <= 10)
          ? piastresArabic
          : piastreArabic;
      return '$formattedNumber $unit';
    } else {
      final unit = absVal == 1 ? 'Piastre' : 'Piastres';
      return '$formattedNumber $unit';
    }
  }

  /// Parses user-entered currency string into a verified [Money] object.
  ///
  /// Handles Eastern Arabic digits (e.g., "١٥٠.٥٠"), currency symbols ("ج.م", "EGP"),
  /// and thousands separators.
  static Money parseInput(String input, [Currency currency = Currency.egp]) {
    var cleaned = input.trim();
    if (cleaned.isEmpty) {
      throw const FormatException('Cannot parse empty string as Money.');
    }

    // Convert Eastern Arabic digits to Western digits
    cleaned = EgyptianNumberFormatter.toWesternArabicDigits(cleaned);

    // Remove currency symbols and non-numeric formatting
    cleaned = cleaned.replaceAll('ج.م', '');
    cleaned = cleaned.replaceAll('EGP', '');
    cleaned = cleaned.replaceAll('egp', '');
    cleaned = cleaned.replaceAll(' ', '');
    cleaned = cleaned.replaceAll(',', '');

    // Now feed into standard safe Money.parse
    return Money.parse(cleaned, currency);
  }

  /// Safe parse that returns null instead of throwing on invalid input.
  static Money? tryParseInput(
    String input, [
    Currency currency = Currency.egp,
  ]) {
    try {
      return parseInput(input, currency);
    } catch (_) {
      return null;
    }
  }
}
