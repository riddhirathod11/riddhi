
import 'package:flutter/material.dart';
import 'food_item.dart';

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onAdd;

  const FoodCard({
    super.key,
    required this.food,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(
              Icons.fastfood,
              size: 42,
              color: Colors.deepOrange,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('₹${food.price.toStringAsFixed(2)}'),
                  Text(
                    food.isAvailable
                        ? 'Available'
                        : 'Out of stock',
                    style: TextStyle(
                      color: food.isAvailable
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: food.isAvailable ? onAdd : null,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
