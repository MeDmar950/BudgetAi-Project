import 'egyptian_number_formatter.dart';

/// Style variants for formatting dates in Egyptian context.
enum EgyptianDateStyle {
  /// e.g. "الجمعة، 20 نوفمبر 2026" or "Friday, November 20, 2026"
  full,

  /// e.g. "20 نوفمبر 2026" or "20 Nov 2026"
  medium,

  /// e.g. "20/11/2026"
  short,

  /// e.g. "نوفمبر 2026" or "November 2026"
  monthYear,
}

/// Helper functions for formatting dates, times, and relative timestamps according to
/// Egyptian culture and language conventions.
final class EgyptianDateFormatter {
  EgyptianDateFormatter._();

  /// Egyptian Gregorian month names in Arabic
  static const List<String> monthsArabic = <String>[
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  /// Gregorian month names in English
  static const List<String> monthsEnglish = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// Short Gregorian month names in English
  static const List<String> monthsEnglishShort = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// Arabic weekday names starting from Monday (DateTime.monday = 1) to Sunday (7)
  static const Map<int, String> weekdaysArabic = <int, String>{
    DateTime.monday: 'الإثنين',
    DateTime.tuesday: 'الثلاثاء',
    DateTime.wednesday: 'الأربعاء',
    DateTime.thursday: 'الخميس',
    DateTime.friday: 'الجمعة',
    DateTime.saturday: 'السبت',
    DateTime.sunday: 'الأحد',
  };

  /// English weekday names
  static const Map<int, String> weekdaysEnglish = <int, String>{
    DateTime.monday: 'Monday',
    DateTime.tuesday: 'Tuesday',
    DateTime.wednesday: 'Wednesday',
    DateTime.thursday: 'Thursday',
    DateTime.friday: 'Friday',
    DateTime.saturday: 'Saturday',
    DateTime.sunday: 'Sunday',
  };

  /// Formats [date] with chosen [style] and [locale].
  static String formatDate(
    DateTime date, {
    String locale = 'ar',
    EgyptianDateStyle style = EgyptianDateStyle.medium,
    bool useEasternDigits = false,
  }) {
    final isArabic = locale.startsWith('ar');
    final monthIndex = date.month - 1;

    String result;
    switch (style) {
      case EgyptianDateStyle.full:
        final weekday = isArabic
            ? (weekdaysArabic[date.weekday] ?? '')
            : (weekdaysEnglish[date.weekday] ?? '');
        final monthName = isArabic
            ? monthsArabic[monthIndex]
            : monthsEnglish[monthIndex];
        result = isArabic
            ? '$weekday، ${date.day} $monthName ${date.year}'
            : '$weekday, $monthName ${date.day}, ${date.year}';
        break;

      case EgyptianDateStyle.medium:
        final monthName = isArabic
            ? monthsArabic[monthIndex]
            : monthsEnglishShort[monthIndex];
        result = isArabic
            ? '${date.day} $monthName ${date.year}'
            : '${date.day} $monthName ${date.year}';
        break;

      case EgyptianDateStyle.short:
        final dayStr = date.day.toString().padLeft(2, '0');
        final monthStr = date.month.toString().padLeft(2, '0');
        result = '$dayStr/$monthStr/${date.year}';
        break;

      case EgyptianDateStyle.monthYear:
        final monthName = isArabic
            ? monthsArabic[monthIndex]
            : monthsEnglish[monthIndex];
        result = '$monthName ${date.year}';
        break;
    }

    if (useEasternDigits) {
      return EgyptianNumberFormatter.toEasternArabicDigits(result);
    }
    return result;
  }

  /// Formats time component of [dateTime] into 12-hour Egyptian Arabic or English notation.
  ///
  /// In Arabic: "04:30 م" or "09:15 ص"
  /// In English: "04:30 PM" or "09:15 AM"
  static String formatTime(
    DateTime dateTime, {
    String locale = 'ar',
    bool use24Hour = false,
    bool useEasternDigits = false,
  }) {
    final isArabic = locale.startsWith('ar');
    final minuteStr = dateTime.minute.toString().padLeft(2, '0');

    String formatted;
    if (use24Hour) {
      final hourStr = dateTime.hour.toString().padLeft(2, '0');
      formatted = '$hourStr:$minuteStr';
    } else {
      final isPm = dateTime.hour >= 12;
      var hour = dateTime.hour % 12;
      if (hour == 0) hour = 12;
      final hourStr = hour.toString().padLeft(2, '0');

      if (isArabic) {
        final period = isPm ? 'م' : 'ص';
        formatted = '$hourStr:$minuteStr $period';
      } else {
        final period = isPm ? 'PM' : 'AM';
        formatted = '$hourStr:$minuteStr $period';
      }
    }

    if (useEasternDigits) {
      return EgyptianNumberFormatter.toEasternArabicDigits(formatted);
    }
    return formatted;
  }

  /// Formats date and time together (e.g. "20 نوفمبر 2026، 04:30 م").
  static String formatDateTime(
    DateTime dateTime, {
    String locale = 'ar',
    EgyptianDateStyle dateStyle = EgyptianDateStyle.medium,
    bool use24Hour = false,
    bool useEasternDigits = false,
  }) {
    final isArabic = locale.startsWith('ar');
    final dateStr = formatDate(
      dateTime,
      locale: locale,
      style: dateStyle,
      useEasternDigits: false,
    );
    final timeStr = formatTime(
      dateTime,
      locale: locale,
      use24Hour: use24Hour,
      useEasternDigits: false,
    );

    final separator = isArabic ? '، ' : ', ';
    final result = '$dateStr$separator$timeStr';

    if (useEasternDigits) {
      return EgyptianNumberFormatter.toEasternArabicDigits(result);
    }
    return result;
  }

  /// Formats relative time (e.g., "الآن", "منذ ساعتين", "أمس", "اليوم") with correct Arabic grammar.
  static String formatRelative(
    DateTime date, {
    DateTime? relativeTo,
    String locale = 'ar',
    bool useEasternDigits = false,
  }) {
    final now = relativeTo ?? DateTime.now();
    final difference = now.difference(date);
    final isArabic = locale.startsWith('ar');

    // Future dates
    if (difference.isNegative) {
      final absDiff = date.difference(now);
      if (absDiff.inDays == 1) {
        return isArabic ? 'غداً' : 'Tomorrow';
      }
      return formatDate(
        date,
        locale: locale,
        style: EgyptianDateStyle.medium,
        useEasternDigits: useEasternDigits,
      );
    }

    final seconds = difference.inSeconds;
    final minutes = difference.inMinutes;
    final hours = difference.inHours;
    final days = difference.inDays;

    String result;

    if (seconds < 60) {
      result = isArabic ? 'الآن' : 'Just now';
    } else if (minutes < 60) {
      result = _formatMinutesAgo(minutes, isArabic: isArabic);
    } else if (hours < 24) {
      result = _formatHoursAgo(hours, isArabic: isArabic);
    } else if (days == 1) {
      result = isArabic ? 'أمس' : 'Yesterday';
    } else if (days < 7) {
      result = _formatDaysAgo(days, isArabic: isArabic);
    } else {
      // For older dates, display medium date
      return formatDate(
        date,
        locale: locale,
        style: EgyptianDateStyle.medium,
        useEasternDigits: useEasternDigits,
      );
    }

    if (useEasternDigits) {
      return EgyptianNumberFormatter.toEasternArabicDigits(result);
    }
    return result;
  }

  static String _formatMinutesAgo(int minutes, {required bool isArabic}) {
    if (!isArabic) {
      return minutes == 1 ? '1 minute ago' : '$minutes minutes ago';
    }
    if (minutes == 1) return 'منذ دقيقة';
    if (minutes == 2) return 'منذ دقيقتين';
    if (minutes >= 3 && minutes <= 10) return 'منذ $minutes دقائق';
    return 'منذ $minutes دقيقة';
  }

  static String _formatHoursAgo(int hours, {required bool isArabic}) {
    if (!isArabic) {
      return hours == 1 ? '1 hour ago' : '$hours hours ago';
    }
    if (hours == 1) return 'منذ ساعة';
    if (hours == 2) return 'منذ ساعتين';
    if (hours >= 3 && hours <= 10) return 'منذ $hours ساعات';
    return 'منذ $hours ساعة';
  }

  static String _formatDaysAgo(int days, {required bool isArabic}) {
    if (!isArabic) {
      return '$days days ago';
    }
    if (days == 2) return 'منذ يومين';
    if (days >= 3 && days <= 10) return 'منذ $days أيام';
    return 'منذ $days يوماً';
  }
}
