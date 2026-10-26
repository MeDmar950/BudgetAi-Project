import 'currency.dart';

/// An immutable financial Money value object.
///
/// BudgetAI strictly avoids binary floating-point (`double`) representation
/// for financial amounts to prevent IEEE 754 precision loss.
/// All monetary values are represented as integer [minorUnits] (e.g., Piastres in EGP).
/// 1 EGP = 100 Piastres.
final class Money implements Comparable<Money> {
  /// The amount in minor units (e.g., 1050 for 10.50 EGP).
  final int minorUnits;

  /// The currency of this money amount. Defaults to [Currency.egp].
  final Currency currency;

  const Money._(this.minorUnits, this.currency);

  /// Creates a Money instance from the exact integer minor units (e.g., piastres).
  const Money.fromMinorUnits(int minorUnits, [Currency currency = Currency.egp])
    : this._(minorUnits, currency);

  /// Creates a Money instance with a zero balance.
  const Money.zero([Currency currency = Currency.egp]) : this._(0, currency);

  /// Creates a Money instance from major units (e.g., integer pounds).
  factory Money.fromMajor(int majorUnits, [Currency currency = Currency.egp]) {
    return Money.fromMinorUnits(
      majorUnits * currency.minorUnitMultiplier,
      currency,
    );
  }

  /// Parses a decimal string (e.g., "150.50", "-25.00", "42") into a Money object.
  /// Throws [FormatException] if the string is invalid or has too many decimal places.
  factory Money.parse(String text, [Currency currency = Currency.egp]) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('Cannot parse empty string as Money.');
    }

    final isNegative = trimmed.startsWith('-');
    final signMultiplier = isNegative ? -1 : 1;
    final unsignedStr = isNegative
        ? trimmed.substring(1).trim()
        : (trimmed.startsWith('+') ? trimmed.substring(1).trim() : trimmed);

    final parts = unsignedStr.split('.');
    if (parts.length > 2) {
      throw FormatException('Invalid number format: $text');
    }

    final majorPart = int.tryParse(parts[0]);
    if (majorPart == null) {
      throw FormatException('Invalid major units in: $text');
    }

    var minorPart = 0;
    if (parts.length == 2) {
      final fracStr = parts[1];
      if (fracStr.length > currency.decimalDigits) {
        throw FormatException(
          'Fractional digits exceed currency precision (${currency.decimalDigits}): $text',
        );
      }
      // Right-pad with zeros to match minor unit multiplier (e.g. .5 -> 50)
      final paddedFrac = fracStr.padRight(currency.decimalDigits, '0');
      final parsedMinor = int.tryParse(paddedFrac);
      if (parsedMinor == null) {
        throw FormatException('Invalid fractional units in: $text');
      }
      minorPart = parsedMinor;
    }

    final totalMinor =
        (majorPart * currency.minorUnitMultiplier + minorPart) * signMultiplier;
    return Money.fromMinorUnits(totalMinor, currency);
  }

  /// Returns major units (truncated integer portion).
  int get majorUnits => minorUnits ~/ currency.minorUnitMultiplier;

  /// Returns the fractional minor unit remainder.
  int get fractionalUnits => (minorUnits % currency.minorUnitMultiplier).abs();

  bool get isZero => minorUnits == 0;
  bool get isPositive => minorUnits > 0;
  bool get isNegative => minorUnits < 0;

  Money abs() => Money.fromMinorUnits(minorUnits.abs(), currency);

  Money operator -() => Money.fromMinorUnits(-minorUnits, currency);

  Money operator +(Money other) {
    _assertSameCurrency(other);
    return Money.fromMinorUnits(minorUnits + other.minorUnits, currency);
  }

  Money operator -(Money other) {
    _assertSameCurrency(other);
    return Money.fromMinorUnits(minorUnits - other.minorUnits, currency);
  }

  /// Multiplies the amount by an integer multiplier.
  Money operator *(int multiplier) {
    return Money.fromMinorUnits(minorUnits * multiplier, currency);
  }

  /// Allocates the amount across given integer ratios without losing a single piastre.
  /// Uses Martin Fowler's Money Allocation Algorithm to guarantee exact summation.
  List<Money> allocate(List<int> ratios) {
    if (ratios.isEmpty) {
      throw ArgumentError('Cannot allocate across empty ratios list');
    }
    final totalRatio = ratios.fold<int>(0, (sum, r) => sum + r);
    if (totalRatio <= 0) {
      throw ArgumentError('Total ratio sum must be strictly positive');
    }

    var remainder = minorUnits;
    final results = <Money>[];

    for (final ratio in ratios) {
      final share = (minorUnits * ratio) ~/ totalRatio;
      results.add(Money.fromMinorUnits(share, currency));
      remainder -= share;
    }

    // Distribute remainder one minor unit at a time to maintain deterministic total
    for (var i = 0; remainder > 0 && i < results.length; i++) {
      results[i] = Money.fromMinorUnits(results[i].minorUnits + 1, currency);
      remainder--;
    }
    for (var i = 0; remainder < 0 && i < results.length; i++) {
      results[i] = Money.fromMinorUnits(results[i].minorUnits - 1, currency);
      remainder++;
    }

    return results;
  }

  /// Formats the money into standard decimal notation (e.g., "120.50").
  String toDecimalString() {
    final sign = isNegative ? '-' : '';
    final absMinor = minorUnits.abs();
    final major = absMinor ~/ currency.minorUnitMultiplier;
    final minor = absMinor % currency.minorUnitMultiplier;
    final minorStr = minor.toString().padLeft(currency.decimalDigits, '0');
    return '$sign$major.$minorStr';
  }

  /// Formats the money with currency symbol based on locale (e.g. "120.50 EGP" or "120.50 ج.م").
  String format([String locale = 'en']) {
    final decimal = toDecimalString();
    final isAr = locale.startsWith('ar');
    final symbol = isAr ? currency.symbolAr : currency.symbolEn;
    return isAr ? '$decimal $symbol' : '$symbol $decimal';
  }

  void _assertSameCurrency(Money other) {
    if (currency != other.currency) {
      throw ArgumentError(
        'Currency mismatch: ${currency.code} cannot operate with ${other.currency.code}',
      );
    }
  }

  @override
  int compareTo(Money other) {
    _assertSameCurrency(other);
    return minorUnits.compareTo(other.minorUnits);
  }

  bool operator <(Money other) => compareTo(other) < 0;
  bool operator <=(Money other) => compareTo(other) <= 0;
  bool operator >(Money other) => compareTo(other) > 0;
  bool operator >=(Money other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Money &&
          runtimeType == other.runtimeType &&
          minorUnits == other.minorUnits &&
          currency == other.currency;

  @override
  int get hashCode => Object.hash(minorUnits, currency);

  @override
  String toString() => '${toDecimalString()} ${currency.code}';
}
