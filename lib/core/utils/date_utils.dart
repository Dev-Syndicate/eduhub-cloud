import 'package:intl/intl.dart';

/// Date and time utility functions
class AppDateUtils {
  AppDateUtils._();

  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('dd MMM yyyy, HH:mm');
  static final DateFormat _shortDateFormat = DateFormat('dd/MM/yy');
  static final DateFormat _monthYearFormat = DateFormat('MMM yyyy');

  /// Format date as "dd MMM yyyy"
  static String formatDate(DateTime date) => _dateFormat.format(date);

  /// Format time as "HH:mm"
  static String formatTime(DateTime date) => _timeFormat.format(date);

  /// Format date and time as "dd MMM yyyy, HH:mm"
  static String formatDateTime(DateTime date) => _dateTimeFormat.format(date);

  /// Format date as "dd/MM/yy"
  static String formatShortDate(DateTime date) => _shortDateFormat.format(date);

  /// Format as "MMM yyyy"
  static String formatMonthYear(DateTime date) => _monthYearFormat.format(date);

  /// Get relative time string (e.g., "2 hours ago", "yesterday")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 2) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  /// Get remaining time string (e.g., "2 hours left", "in 3 days")
  static String getRemainingTime(DateTime date) {
    final now = DateTime.now();
    if (now.isAfter(date)) {
      return 'Overdue';
    }

    final difference = date.difference(now);

    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} left';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} left';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} left';
    } else {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} left';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
}
