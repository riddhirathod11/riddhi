3.Build a reusable OfferBanner widget that takes an image URL and offer text as parameters and displays them together. 
Use this widget at the top of both a food delivery home screen and a shopping deals screen to demonstrate reusability.


import 'package:flutter/material.dart';

class OfferBanner extends StatelessWidget {
  final String imageUrl;
  final String offerText;

  const OfferBanner({
    super.key,
    required this.imageUrl,
    required this.offerText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.deepOrange,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.local_offer,
                    size: 50,
                    color: Colors.white,
                  ),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: Text(
                offerText,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
