double addServiceCharge(double price) {
  return price + (price * 0.05);
}

void main() {
  double order1 = addServiceCharge(500);
  double order2 = addServiceCharge(800);
  double order3 = addServiceCharge(1200);

  print("Order 1 Total: ₹$order1");
  print("Order 2 Total: ₹$order2");
  print("Order 3 Total: ₹$order3");
}