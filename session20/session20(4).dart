import 'dart:math';

String processPayment() {
  bool paymentFailed = Random().nextBool();

  if (paymentFailed) {
    throw Exception('Payment failed due to server error');
  }

  return 'Payment Successful';
}

void main() {
  try {
    String result = processPayment();

    print(result);
  } catch (e) {
    print('Payment Failed: ${e.toString().replaceFirst('Exception: ', '')}');
  }
}