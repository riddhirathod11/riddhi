import 'dart:async';

Future<String> getOrderStatus() async {
  // Simulate checking Zomato order status for 3 seconds
  await Future.delayed(const Duration(seconds: 3));

  return 'Order Delivered';
}

void main() async {
  String status = await getOrderStatus();

  print(status);
}