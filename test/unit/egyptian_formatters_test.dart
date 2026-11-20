import 'package:flutter_test/flutter_test.dart';
import 'package:budget_ai/core/localization/localization_helpers.dart';
import 'package:budget_ai/core/money/money.dart';

void main() {
  group('EgyptianNumberFormatter Tests', () {
    test('converts ASCII digits to Eastern Arabic digits correctly', () {
      expect(
        EgyptianNumberFormatter.toEasternArabicDigits('0123456789'),
        '٠١٢٣٤٥٦٧٨٩',
      );
      expect(
        EgyptianNumberFormatter.toEasternArabicDigits('Phone: 01012345678'),
        'Phone: ٠١٠١٢٣٤٥٦٧٨',
      );
    });

    test(
      'converts Eastern Arabic digits to Western ASCII digits correctly',
      () {
        expect(
          EgyptianNumberFormatter.toWesternArabicDigits('٠١٢٣٤٥٦٧٨٩'),
          '0123456789',
        );
        expect(
          EgyptianNumberFormatter.toWesternArabicDigits('١٥٠٫٥٠'),
          '150.50',
        );
        expect(
          EgyptianNumberFormatter.toWesternArabicDigits('١،٢٥٠٫٥٠'),
          '1,250.50',
        );
      },
    );

    test('formats integer with Egyptian grouping and digits', () {
      expect(EgyptianNumberFormatter.formatInteger(1000), '1,000');
      expect(EgyptianNumberFormatter.formatInteger(1234567), '1,234,567');
      expect(
        EgyptianNumberFormatter.formatInteger(1234567, useEasternDigits: true),
        '١،٢٣٤،٥٦٧',
      );
      expect(EgyptianNumberFormatter.formatInteger(-5000), '-5,000');
      expect(
        EgyptianNumberFormatter.formatInteger(42, useGrouping: false),
        '42',
      );
    });

    test('formats decimal parts without double conversion', () {
      expect(
        EgyptianNumberFormatter.formatDecimalParts(
          majorUnits: 150,
          minorUnits: 50,
        ),
        '150.50',
      );
      expect(
        EgyptianNumberFormatter.formatDecimalParts(
          majorUnits: 1250,
          minorUnits: 5,
          useEasternDigits: true,
        ),
        '١،٢٥٠٫٠٥',
      );
    });

    test('formats Egyptian mobile phone numbers properly', () {
      expect(
        EgyptianNumberFormatter.formatEgyptianPhoneNumber('01012345678'),
        '010 1234 5678',
      );
      expect(
        EgyptianNumberFormatter.formatEgyptianPhoneNumber(
          '01012345678',
          includeCountryCode: true,
        ),
        '+20 10 1234 5678',
      );
      expect(
        EgyptianNumberFormatter.formatEgyptianPhoneNumber('٠١١٩٨٧٦٥٤٣٢'),
        '011 9876 5432',
      );
    });
  });

  group('EgyptianCurrencyFormatter Tests', () {
    test('formats Money in Egyptian Arabic and English locales', () {
      final money = Money.fromMinorUnits(125050); // 1,250.50 EGP

      expect(
        EgyptianCurrencyFormatter.format(money, locale: 'ar'),
        '1,250.50 ج.م',
      );
      expect(
        EgyptianCurrencyFormatter.format(
          money,
          locale: 'ar',
          useEasternDigits: true,
        ),
        '١،٢٥٠٫٥٠ ج.م',
      );
      expect(
        EgyptianCurrencyFormatter.format(money, locale: 'en'),
        'EGP 1,250.50',
      );
    });

    test('formats signed currency amounts for ledgers', () {
      final income = Money.fromMinorUnits(500000); // 5,000.00
      final expense = Money.fromMinorUnits(-25000); // -250.00

      expect(
        EgyptianCurrencyFormatter.format(income, locale: 'ar', showSign: true),
        '+5,000.00 ج.م',
      );
      expect(
        EgyptianCurrencyFormatter.format(expense, locale: 'ar', showSign: true),
        '-250.00 ج.م',
      );
    });

    test('formats compact money notation for dashboards and cards', () {
      final thousands = Money.fromMinorUnits(150000); // 1,500.00
      final millions = Money.fromMinorUnits(250000000); // 2,500,000.00

      expect(
        EgyptianCurrencyFormatter.formatCompact(thousands, locale: 'ar'),
        '1.5 ألف ج.م',
      );
      expect(
        EgyptianCurrencyFormatter.formatCompact(millions, locale: 'ar'),
        '2.5 مليون ج.م',
      );
      expect(
        EgyptianCurrencyFormatter.formatCompact(thousands, locale: 'en'),
        'EGP 1.5K',
      );
      expect(
        EgyptianCurrencyFormatter.formatCompact(millions, locale: 'en'),
        'EGP 2.5M',
      );
    });

    test('formats piastres with grammatical rules', () {
      expect(
        EgyptianCurrencyFormatter.formatPiastres(1, locale: 'ar'),
        '1 قرش',
      );
      expect(
        EgyptianCurrencyFormatter.formatPiastres(5, locale: 'ar'),
        '5 قروش',
      );
      expect(
        EgyptianCurrencyFormatter.formatPiastres(50, locale: 'ar'),
        '50 قرش',
      );
      expect(
        EgyptianCurrencyFormatter.formatPiastres(50, locale: 'en'),
        '50 Piastres',
      );
    });

    test(
      'parses Egyptian user input with Arabic digits and symbols safely',
      () {
        final money1 = EgyptianCurrencyFormatter.parseInput('150.50 ج.م');
        expect(money1.minorUnits, 15050);

        final money2 = EgyptianCurrencyFormatter.parseInput('١٥٠٫٥٠ ج.م');
        expect(money2.minorUnits, 15050);

        final money3 = EgyptianCurrencyFormatter.parseInput('EGP 2,500.00');
        expect(money3.minorUnits, 250000);

        final money4 = EgyptianCurrencyFormatter.tryParseInput('invalid_text');
        expect(money4, isNull);
      },
    );
  });

  group('EgyptianDateFormatter Tests', () {
    final testDate = DateTime(
      2026,
      11,
      20,
      16,
      30,
    ); // Friday Nov 20, 2026 4:30 PM

    test('formats full Egyptian date with Arabic month and day names', () {
      final formattedAr = EgyptianDateFormatter.formatDate(
        testDate,
        locale: 'ar',
        style: EgyptianDateStyle.full,
      );
      expect(formattedAr, contains('الجمعة'));
      expect(formattedAr, contains('نوفمبر'));
      expect(formattedAr, contains('2026'));

      final formattedEn = EgyptianDateFormatter.formatDate(
        testDate,
        locale: 'en',
        style: EgyptianDateStyle.full,
      );
      expect(formattedEn, 'Friday, November 20, 2026');
    });

    test('formats medium and short dates', () {
      expect(
        EgyptianDateFormatter.formatDate(
          testDate,
          locale: 'ar',
          style: EgyptianDateStyle.medium,
        ),
        '20 نوفمبر 2026',
      );
      expect(
        EgyptianDateFormatter.formatDate(
          testDate,
          locale: 'ar',
          style: EgyptianDateStyle.short,
        ),
        '20/11/2026',
      );
    });

    test('formats Egyptian 12-hour time with ص and م markers', () {
      final morning = DateTime(2026, 11, 20, 9, 15);
      final evening = DateTime(2026, 11, 20, 16, 30);

      expect(
        EgyptianDateFormatter.formatTime(morning, locale: 'ar'),
        '09:15 ص',
      );
      expect(
        EgyptianDateFormatter.formatTime(evening, locale: 'ar'),
        '04:30 م',
      );
      expect(
        EgyptianDateFormatter.formatTime(evening, locale: 'en'),
        '04:30 PM',
      );
      expect(
        EgyptianDateFormatter.formatTime(evening, use24Hour: true),
        '16:30',
      );
    });

    test('formats relative dates with Arabic dual and plural grammar', () {
      final now = DateTime(2026, 11, 20, 12, 0);

      expect(
        EgyptianDateFormatter.formatRelative(
          now.subtract(const Duration(seconds: 30)),
          relativeTo: now,
          locale: 'ar',
        ),
        'الآن',
      );

      expect(
        EgyptianDateFormatter.formatRelative(
          now.subtract(const Duration(minutes: 1)),
          relativeTo: now,
          locale: 'ar',
        ),
        'منذ دقيقة',
      );

      expect(
        EgyptianDateFormatter.formatRelative(
          now.subtract(const Duration(minutes: 2)),
          relativeTo: now,
          locale: 'ar',
        ),
        'منذ دقيقتين',
      );

      expect(
        EgyptianDateFormatter.formatRelative(
          now.subtract(const Duration(minutes: 5)),
          relativeTo: now,
          locale: 'ar',
        ),
        'منذ 5 دقائق',
      );

      expect(
        EgyptianDateFormatter.formatRelative(
          now.subtract(const Duration(minutes: 25)),
          relativeTo: now,
          locale: 'ar',
        ),
        'منذ 25 دقيقة',
      );

      expect(
        EgyptianDateFormatter.formatRelative(
          now.subtract(const Duration(hours: 1)),
          relativeTo: now,
          locale: 'ar',
        ),
        'منذ ساعة',
      );

      expect(
        EgyptianDateFormatter.formatRelative(
          now.subtract(const Duration(hours: 2)),
          relativeTo: now,
          locale: 'ar',
        ),
        'منذ ساعتين',
      );

      expect(
        EgyptianDateFormatter.formatRelative(
          now.subtract(const Duration(hours: 5)),
          relativeTo: now,
          locale: 'ar',
        ),
        'منذ 5 ساعات',
      );

      expect(
        EgyptianDateFormatter.formatRelative(
          now.subtract(const Duration(days: 1)),
          relativeTo: now,
          locale: 'ar',
        ),
        'أمس',
      );

      expect(
        EgyptianDateFormatter.formatRelative(
          now.subtract(const Duration(days: 2)),
          relativeTo: now,
          locale: 'ar',
        ),
        'منذ يومين',
      );

      expect(
        EgyptianDateFormatter.formatRelative(
          now.subtract(const Duration(days: 4)),
          relativeTo: now,
          locale: 'ar',
        ),
        'منذ 4 أيام',
      );
    });
  });

  group('Egyptian Extensions Tests', () {
    test('Money and DateTime extensions format seamlessly', () {
      final money = Money.fromMinorUnits(350075);
      final date = DateTime(2026, 11, 20, 14, 0);

      expect(money.formatEgyptian(), '3,500.75 ج.م');
      expect(money.formatSigned(), '+3,500.75 ج.م');
      expect(money.formatCompact(), '3.5 ألف ج.م');

      expect(date.toEgyptianDate(), '20 نوفمبر 2026');
      expect(date.toEgyptianTime(), '02:00 م');

      expect('١٢٣٤٥'.toWesternArabicDigits(), '12345');
      expect('12345'.toEasternArabicDigits(), '١٢٣٤٥');

      final parsed = '٢٥٠٫٠٠ ج.م'.parseAsMoney();
      expect(parsed.minorUnits, 25000);
    });
  });
}
