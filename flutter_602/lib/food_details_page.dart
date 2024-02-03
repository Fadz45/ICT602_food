// food_details_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_602/food_model.dart';

class FoodDetailsPage extends StatelessWidget {
  final Food food;

  FoodDetailsPage({required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Details'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Name: ${food.name}'),
          Text('Description: ${food.description}'),
          Text('Price: RM${food.price}'),
          // Add more food details if needed
        ],
      ),
    );
  }
}
