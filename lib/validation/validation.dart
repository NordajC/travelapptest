class inputValidator {

  //empthy text validator
  static String? validateEmpty(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

    static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    // Minimum 8 characters, at least one uppercase letter, one lowercase letter, one number and one special character
    String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Password must be at least 8 characters, include an uppercase letter, a lowercase letter, a number, and a special character.';
    }
    return null;
  }

    static String? phoneNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    // General pattern for a phone number (adjust as needed)
    // This example allows optional + prefix, at least 10 digits, and ignores spaces, dashes, and parentheses.
    String pattern =
        r'^\+?(\d[\d- ]{9,}\d$)';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}