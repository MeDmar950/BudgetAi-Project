import 'package:flutter_test/flutter_test.dart';
import 'package:budget_ai/core/money/currency.dart';
import 'package:budget_ai/core/money/money.dart';

void main() {
  group('Money Value Object', () {
    test('creates money from minor units correctly', () {
      final money = Money.fromMinorUnits(15050); // 150.50 EGP
      expect(money.minorUnits, 15050);
      expect(money.majorUnits, 150);
      expect(money.fractionalUnits, 50);
      expect(money.currency, Currency.egp);
      expect(money.toDecimalString(), '150.50');
    });

    test('creates money from major units correctly', () {
      final money = Money.fromMajor(250);
      expect(money.minorUnits, 25000);
      expect(money.toDecimalString(), '250.00');
    });

    test('handles negative money correctly', () {
      final negative = Money.fromMinorUnits(-12050);
      expect(negative.isNegative, isTrue);
      expect(negative.isPositive, isFalse);
      expect(negative.majorUnits, -120);
      expect(negative.fractionalUnits, 50);
      expect(negative.toDecimalString(), '-120.50');
      expect(negative.abs().minorUnits, 12050);
      expect((-negative).minorUnits, 12050);
    });

    test('adds and subtracts money accurately without binary float errors', () {
      // In binary float: 0.1 + 0.2 = 0.30000000000000004
      // In Money (piastres): 10 + 20 = 30 exactly
      final a = Money.fromMinorUnits(10);
      final b = Money.fromMinorUnits(20);
      final sum = a + b;
      expect(sum.minorUnits, 30);
      expect(sum.toDecimalString(), '0.30');

      final diff = b - a;
      expect(diff.minorUnits, 10);
      expect(diff.toDecimalString(), '0.10');
    });

    test('parses decimal string safely', () {
      expect(Money.parse('150.50').minorUnits, 15050);
      expect(Money.parse('150.5').minorUnits, 15050);
      expect(Money.parse('150').minorUnits, 15000);
      expect(Money.parse('-42.25').minorUnits, -4225);
      expect(Money.parse('0.00').isZero, isTrue);
    });

    test(
      'throws FormatException on invalid decimal strings or excessive precision',
      () {
        expect(() => Money.parse(''), throwsFormatException);
        expect(() => Money.parse('abc'), throwsFormatException);
        expect(
          () => Money.parse('12.345'),
          throwsFormatException,
        ); // exceeds 2 decimal places
      },
    );

    test('formats correctly for English and Arabic locales', () {
      final money = Money.fromMinorUnits(15050);
      expect(money.format('en'), 'EGP 150.50');
      expect(money.format('ar'), '150.50 ج.م');
    });

    test('allocates money across ratios without losing single piastre', () {
      // 100 piastres split 3 ways (1:1:1) should produce [34, 33, 33]
      final total = Money.fromMinorUnits(100);
      final shares = total.allocate([1, 1, 1]);

      expect(shares.length, 3);
      expect(shares[0].minorUnits, 34);
      expect(shares[1].minorUnits, 33);
      expect(shares[2].minorUnits, 33);

      // Verify exact sum invariant
      final sumMinor = shares.fold<int>(0, (acc, m) => acc + m.minorUnits);
      expect(sumMinor, 100);
    });

    test('compares money amounts correctly', () {
      final smaller = Money.fromMinorUnits(1000);
      final larger = Money.fromMinorUnits(2000);
      final equal = Money.fromMinorUnits(1000);

      expect(smaller < larger, isTrue);
      expect(larger > smaller, isTrue);
      expect(smaller == equal, isTrue);
      expect(smaller <= equal, isTrue);
    });

    test('throws error on currency mismatch', () {
      const foreignCurrency = Currency(
        code: 'USD',
        symbolEn: r'$',
        symbolAr: r'$',
        decimalDigits: 2,
      );
      final egp = Money.fromMinorUnits(1000, Currency.egp);
      final usd = Money.fromMinorUnits(1000, foreignCurrency);

      expect(() => egp + usd, throwsArgumentError);
      expect(() => egp - usd, throwsArgumentError);
      expect(() => egp.compareTo(usd), throwsArgumentError);
    });
  });
}
