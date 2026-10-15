Build a multi-screen Flutter application for a food delivery service that combines Dart OOPmodels, a stateful cart with live total updates, reusable custom widgets,
app-wide theming, andnamed-route navigation into a single cohesive app shell.


class FoodItem {
  final String name;
  final double price;
  final bool isAvailable;

  const FoodItem({
    required this.name,
    required this.price,
    required this.isAvailable,
  });
}

final List<FoodItem> cartItems = [];

final List<FoodItem> foodMenu = [
  FoodItem(name: 'Pizza', price: 150, isAvailable: true),
  FoodItem(name: 'Burger', price: 80, isAvailable: true),
  FoodItem(name: 'Pasta', price: 120, isAvailable: true),
  FoodItem(name: 'Sandwich', price: 60, isAvailable: false),
];
