/// Helper functions for converting and formatting numbers according to
/// Egyptian and Arabic conventions.
final class EgyptianNumberFormatter {
  EgyptianNumberFormatter._();

  static const List<String> _westernDigits = <String>[
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];

  static const List<String> _easternArabicDigits = <String>[
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩',
  ];

  /// Converts any Western ASCII digits (0-9) in [text] to Eastern Arabic digits (٠-٩).
  static String toEasternArabicDigits(String text) {
    var result = text;
    for (var i = 0; i < 10; i++) {
      result = result.replaceAll(_westernDigits[i], _easternArabicDigits[i]);
    }
    return result;
  }

  /// Converts any Eastern Arabic digits (٠-٩) in [text] to Western ASCII digits (0-9).
  /// Also normalizes Arabic decimal separator '٫' to '.' and Arabic thousand separator '،' to ','.
  static String toWesternArabicDigits(String text) {
    var result = text;
    for (var i = 0; i < 10; i++) {
      result = result.replaceAll(_easternArabicDigits[i], _westernDigits[i]);
    }
    // Normalize Arabic decimal and thousands separators
    result = result.replaceAll('٫', '.');
    result = result.replaceAll('،', ',');
    return result;
  }

  /// Formats an integer with thousands grouping separator (e.g., 1,234,567).
  ///
  /// If [useEasternDigits] is true, digits are formatted as Eastern Arabic (١،٢٣٤،٥٦٧).
  static String formatInteger(
    int number, {
    bool useGrouping = true,
    bool useEasternDigits = false,
  }) {
    final isNegative = number < 0;
    final absStr = number.abs().toString();

    String groupedStr;
    if (useGrouping && absStr.length > 3) {
      final buffer = StringBuffer();
      final len = absStr.length;
      final firstGroupLen = len % 3 == 0 ? 3 : len % 3;

      buffer.write(absStr.substring(0, firstGroupLen));
      for (var i = firstGroupLen; i < len; i += 3) {
        buffer.write(',');
        buffer.write(absStr.substring(i, i + 3));
      }
      groupedStr = buffer.toString();
    } else {
      groupedStr = absStr;
    }

    final fullStr = isNegative ? '-$groupedStr' : groupedStr;

    if (useEasternDigits) {
      return toEasternArabicDigits(fullStr).replaceAll(',', '،');
    }
    return fullStr;
  }

  /// Formats major and minor integer parts safely without converting to double.
  static String formatDecimalParts({
    required int majorUnits,
    required int minorUnits,
    int decimalDigits = 2,
    bool useGrouping = true,
    bool useEasternDigits = false,
  }) {
    final isNegative = majorUnits < 0 || minorUnits < 0;
    final absMajor = majorUnits.abs();
    final absMinor = minorUnits.abs();

    final majorFormatted = formatInteger(
      absMajor,
      useGrouping: useGrouping,
      useEasternDigits: false,
    );
    final minorFormatted = absMinor.toString().padLeft(decimalDigits, '0');

    final result = '$majorFormatted.$minorFormatted';
    final signedResult = isNegative ? '-$result' : result;

    if (useEasternDigits) {
      return toEasternArabicDigits(signedResult)
          .replaceAll(',', '،')
          .replaceAll('.', '٫');
    }
    return signedResult;
  }

  /// Parses an Egyptian phone number or text containing Arabic/Western digits into clean ASCII digits.
  static String cleanDigits(String input) {
    return toWesternArabicDigits(input).replaceAll(RegExp(r'\D'), '');
  }

  /// Formats an Egyptian phone number (e.g. 01012345678 -> "010 1234 5678").
  static String formatEgyptianPhoneNumber(
    String phone, {
    bool useEasternDigits = false,
    bool includeCountryCode = false,
  }) {
    final digits = cleanDigits(phone);
    String national;

    if (digits.startsWith('20') && digits.length >= 12) {
      national = digits.substring(2);
    } else if (digits.startsWith('0') && digits.length >= 11) {
      national = digits;
    } else if (digits.length == 10) {
      national = '0$digits';
    } else {
      national = digits;
    }

    String formatted;
    if (national.length == 11) {
      final prefix = national.substring(0, 3); // 010, 011, 012, 015
      final part1 = national.substring(3, 7);
      final part2 = national.substring(7);
      formatted = includeCountryCode
          ? '+20 ${prefix.substring(1)} $part1 $part2'
          : '$prefix $part1 $part2';
    } else {
      formatted = national;
    }

    return useEasternDigits ? toEasternArabicDigits(formatted) : formatted;
  }
}
