import 'package:flutter/material.dart';
import 'package:flutter_602/food_details_page.dart';
import 'package:flutter_602/user_model.dart'; // Import the AppUser class
import 'package:flutter_602/food_model.dart'; // Import the Food class
import 'package:flutter_602/firebase_auth_service.dart';

class FavoriteFoodsPage extends StatefulWidget {
  final AppUser user;

  FavoriteFoodsPage({required this.user});

  @override
  _FavoriteFoodsPageState createState() => _FavoriteFoodsPageState();
}

class _FavoriteFoodsPageState extends State<FavoriteFoodsPage> {
  late List<Food> favoriteFoods = [];

  @override
  void initState() {
    super.initState();
    loadFavoriteFoods();
  }

  Future<void> loadFavoriteFoods() async {
    FirebaseAuthService authService = FirebaseAuthService();
    List<Food> foods = await authService.getFavoriteFoods(widget.user.uid);
    setState(() {
      favoriteFoods = foods;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Foods'),
      ),
      body: favoriteFoods != null
          ? ListView.builder(
              itemCount: favoriteFoods.length,
              itemBuilder: (context, index) {
                final food = favoriteFoods[index];
                return ListTile(
                  title: Text(food.name),
                  subtitle: Text('${food.description} - RM${food.price}'),
                  onTap: () {
                    // Navigate to food details page when a food item is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FoodDetailsPage(food: food)),
                    );
                  },
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a page where the user can add a new favorite food
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFavoriteFoodPage(user: widget.user)),
          ).then((_) {
            // Reload the list of favorite foods after returning from the add food page
            loadFavoriteFoods();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddFavoriteFoodPage extends StatefulWidget {
  final AppUser user;

  AddFavoriteFoodPage({required this.user});

  @override
  _AddFavoriteFoodPageState createState() => _AddFavoriteFoodPageState();
}

class _AddFavoriteFoodPageState extends State<AddFavoriteFoodPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Favorite Food'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Food Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                double price = double.tryParse(_priceController.text) ?? 0.0;
                if (price > 0) {
                  await FirebaseAuthService().addFavoriteFood(
                    widget.user.uid,
                    _nameController.text,
                    _descriptionController.text,
                    price,
                  );
                  Navigator.pop(context); // Close the add food page
                } else {
                  // Show an error message for invalid price
                  // You can implement your own error handling mechanism
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Center(
                  child: Text(
                    'Add Food',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}