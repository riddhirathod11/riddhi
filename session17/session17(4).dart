bool validatePhoneNumber(String phone) {
  if (phone.length == 10 &&
      phone.startsWith(RegExp(r'[6-9]')) &&
      int.tryParse(phone) != null) {
    return true;
  } else {
    return false;
  }
}

void main() {
  print(validatePhoneNumber("9876543210")); // true
  print(validatePhoneNumber("5123456789")); // false
  print(validatePhoneNumber("987654321"));  // false
}