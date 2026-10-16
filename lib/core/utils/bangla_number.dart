class BanglaNumber {
  BanglaNumber._();

  static const Map<String, String> _englishToBanglaDigits = {
    '0': '০',
    '1': '১',
    '2': '২',
    '3': '৩',
    '4': '৪',
    '5': '৫',
    '6': '৬',
    '7': '৭',
    '8': '৮',
    '9': '৯',
  };

  static const Map<String, String> _banglaToEnglishDigits = {
    '০': '0',
    '১': '1',
    '২': '2',
    '৩': '3',
    '৪': '4',
    '৫': '5',
    '৬': '6',
    '৭': '7',
    '৮': '8',
    '৯': '9',
  };

  /// Converts English numbers/digits in a string to Bangla digits.
  static String toBangla(dynamic input) {
    if (input == null) return '';
    String str = input.toString();
    _englishToBanglaDigits.forEach((en, bn) {
      str = str.replaceAll(en, bn);
    });
    return str;
  }

  /// Converts Bangla digits in a string to English digits.
  static String toEnglish(String input) {
    String str = input;
    _banglaToEnglishDigits.forEach((bn, en) {
      str = str.replaceAll(bn, en);
    });
    return str;
  }

  /// Formats currency to ৳১,০০০ format.
  static String formatCurrency(num amount) {
    return '৳${toBangla(amount.toString())}';
  }
}
