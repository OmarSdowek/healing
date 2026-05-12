/// Utility for appointment date/time formatting and weekday mapping.
/// Single responsibility: date-related transformations only.
class AppointmentDateHelper {
  AppointmentDateHelper._();

  static const _days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday',
  ];

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// Formats an ISO date string to "Monday, Jan 6 - 09:00 AM"
  static String formatAppointmentDate(String? isoDate) {
    if (isoDate == null) return '--';
    try {
      final dt = DateTime.parse(isoDate);
      final time = isoDate.contains('T')
          ? isoDate.split('T')[1].substring(0, 5)
          : '';
      final timeFormatted = time.isNotEmpty ? ' - ${to12h(time)}' : '';
      return '${_days[(dt.weekday - 1).clamp(0, 6)]}, '
          '${_months[(dt.month - 1).clamp(0, 11)]} ${dt.day}'
          '$timeFormatted';
    } catch (_) {
      return isoDate;
    }
  }

  /// Converts 24h time string "14:30" to "2:30 PM"
  static String to12h(String time24) {
    if (time24.length < 5) return time24;
    try {
      final parts = time24.split(':');
      int hour = int.parse(parts[0]);
      final min = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      return '$hour:$min $period';
    } catch (_) {
      return time24;
    }
  }

  /// Formats a DateTime to "YYYY-MM-DD"
  static String formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Converts day name string to DateTime weekday number (1=Mon … 7=Sun).
  static int? dayNameToWeekday(String? day) {
    switch (day?.toLowerCase()) {
      case 'monday':    return 1;
      case 'tuesday':   return 2;
      case 'wednesday': return 3;
      case 'thursday':  return 4;
      case 'friday':    return 5;
      case 'saturday':  return 6;
      case 'sunday':    return 7;
      default:          return null;
    }
  }

  /// Calculates age in years from a date-of-birth string.
  static int? calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null) return null;
    try {
      final dob = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return null;
    }
  }
}
