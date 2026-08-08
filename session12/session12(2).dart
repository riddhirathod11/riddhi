import 'dart:io';
void main()
{
  List<String> cart=["Laptop", "Headphones", "Smartphone", "Shoes"];

while (cart.isNotEmpty) {
  var product = cart.removeAt(0);
  print("cart is $cart");
}
print("cart is empty");
}
