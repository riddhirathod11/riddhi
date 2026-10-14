
import 'package:flutter/material.dart';
import 'offer_banner.dart';

class FoodHomeScreen extends StatelessWidget {
  const FoodHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Delivery'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: const [
          OfferBanner(
            imageUrl:
                'https://picsum.photos/id/292/800/400',
            offerText: '50% OFF on Food!',
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Popular Restaurants',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.restaurant, color: Colors.deepOrange),
            title: Text('Spice Garden'),
            subtitle: Text('North Indian Cuisine'),
          ),
          ListTile(
            leading: Icon(Icons.local_pizza, color: Colors.deepOrange),
            title: Text('Pizza Corner'),
            subtitle: Text('Italian Cuisine'),
          ),
        ],
      ),
    );
  }
}
