import 'dart:io';
void main() {
  print("enter your age");
  var age = int.parse(stdin.readLineSync().toString());
  if (age <= 22) {
    print("Eligible for student discount");
  }
  else {
    print("not eligible discount");
  }
}