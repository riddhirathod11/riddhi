
import 'package:flutter/material.dart';
import 'food_home_screen.dart';
import 'shopping_deals_screen.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeMenu(),
    ),
  );
}

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offer Banner Demo'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const FoodHomeScreen(),
                  ),
                );
              },
              child: const Text('Food Delivery'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ShoppingDealsScreen(),
                  ),
                );
              },
              child: const Text('Shopping Deals'),
            ),
          ],
        ),
      ),
    );
  }
}
