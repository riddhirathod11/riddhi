import 'dart:io';
void main() {
  print("enter your orders");
  var orders = int.parse(stdin.readLineSync().toString());
  if (orders <= 200) {
    print("charges 50");
  }
  else if (orders <= 500) {
    print("charges 20");
  }
  else {
    print("delivary is free");
  }
}
