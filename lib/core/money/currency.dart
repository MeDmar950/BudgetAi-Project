/// Default currency for BudgetAI is Egyptian Pound (EGP).
final class Currency {
  final String code; // e.g., 'EGP'
  final String symbolEn; // e.g., 'EGP'
  final String symbolAr; // e.g., 'ج.م'
  final int
  decimalDigits; // Minor unit ratio exponent (2 for EGP: 100 piastres = 1 EGP)

  const Currency({
    required this.code,
    required this.symbolEn,
    required this.symbolAr,
    this.decimalDigits = 2,
  });

  /// Egyptian Pound (1 EGP = 100 Piastres)
  static const Currency egp = Currency(
    code: 'EGP',
    symbolEn: 'EGP',
    symbolAr: 'ج.م',
    decimalDigits: 2,
  );

  /// Multiplier to convert between major and minor units (100 for 2 digits)
  int get minorUnitMultiplier {
    var multiplier = 1;
    for (var i = 0; i < decimalDigits; i++) {
      multiplier *= 10;
    }
    return multiplier;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => code;
}
