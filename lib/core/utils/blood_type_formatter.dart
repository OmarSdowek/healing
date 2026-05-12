/// Converts API blood type strings to display format.
/// e.g. "APositive" → "A+", "BNegative" → "B-"
class BloodTypeFormatter {
  BloodTypeFormatter._();

  static const _map = {
    'apositive': 'A+',
    'anegative': 'A-',
    'bpositive': 'B+',
    'bnegative': 'B-',
    'abpositive': 'AB+',
    'abnegative': 'AB-',
    'opositive': 'O+',
    'onegative': 'O-',
  };

  /// Returns formatted blood type or the original string if not found.
  static String? format(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return _map[raw.toLowerCase()] ?? raw;
  }
}
