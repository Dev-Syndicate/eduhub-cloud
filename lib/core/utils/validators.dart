/// Input validation utilities
class Validators {
  Validators._();

  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate campus email (customize domain as needed)
  static String? validateCampusEmail(String? value, {String? domain}) {
    final emailError = validateEmail(value);
    if (emailError != null) return emailError;

    if (domain != null && !value!.endsWith('@$domain')) {
      return 'Please use your campus email (@$domain)';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(String? value, int minLength,
      {String? fieldName}) {
    if (value == null || value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }
    return null;
  }

  /// Validate maximum length
  static String? validateMaxLength(String? value, int maxLength,
      {String? fieldName}) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'This field'} must be at most $maxLength characters';
    }
    return null;
  }

  /// Validate phone number
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }

    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-()]'), ''))) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Validate positive number
  static String? validatePositiveNumber(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    final number = int.tryParse(value);
    if (number == null || number < 0) {
      return 'Please enter a valid positive number';
    }

    return null;
  }

  /// Validate date is in the future
  static String? validateFutureDate(DateTime? date, {String? fieldName}) {
    if (date == null) {
      return '${fieldName ?? 'Date'} is required';
    }

    if (date.isBefore(DateTime.now())) {
      return '${fieldName ?? 'Date'} must be in the future';
    }

    return null;
  }

  /// Validate URL format
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }
}
