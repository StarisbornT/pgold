class Utils {
  static String normalizePhoneNumber(String input) {
    String phone = input.trim();

    if (phone.startsWith('+234')) {
      return phone; // already in correct format
    }

    if (phone.startsWith('0')) {
      phone = phone.substring(1); // remove leading 0
    }

    // Remove any spaces, dashes, or brackets
    phone = phone.replaceAll(RegExp(r'\D'), '');

    return '0$phone';
  }

}