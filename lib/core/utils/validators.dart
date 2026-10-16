class Validators {
  Validators._();

  /// Validates a Bangladeshi mobile number (11 digits starting with 01)
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'মোবাইল নম্বর লিখুন';
    }
    final clean = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.length != 11 || !clean.startsWith('01')) {
      return 'সঠিক ১১ ডিজিটের মোবাইল নম্বর দিন (যেমন: 01712345678)';
    }
    return null;
  }

  /// Validates required text fields
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName প্রদান করুন';
    }
    return null;
  }

  /// Validates passwords
  static String? validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে';
    }
    return null;
  }

  /// Validates optional email (valid format if provided, empty is valid)
  static String? validateOptionalEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'সঠিক ইমেইল ঠিকানা দিন (অথবা ফাঁকা রাখুন)';
    }
    return null;
  }

  /// Validates either Bangladeshi phone or email for login screen
  static String? validatePhoneOrEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'মোবাইল নম্বর অথবা ইমেইল লিখুন';
    }
    final trimmed = value.trim();
    if (trimmed.contains('@')) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(trimmed)) {
        return 'সঠিক ইমেইল ঠিকানা লিখুন';
      }
      return null;
    }
    return validatePhone(trimmed);
  }
}

