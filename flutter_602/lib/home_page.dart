// home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_602/firebase_auth_service.dart';
import 'package:flutter_602/user_model.dart';
import 'package:flutter_602/user_profile_page.dart';
import 'favorite_food_page.dart';

enum UserUpdateResult { success, error }

class HomePage extends StatefulWidget {
  final AppUser user;

  HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppUser _updatedUser;

  @override
  void initState() {
    super.initState();
    _updatedUser = widget.user;
    _fetchUserDetails(); // Fetch user details when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () async {
              // Navigate to User Profile Page and wait for the result
              final result = await Navigator.push<UserUpdateResult>(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(user: _updatedUser),
                ),
              );

              // Fetch the latest user details again if the result is success
              if (result == UserUpdateResult.success) {
                await _fetchUserDetails();
              }
            },
            icon: Icon(Icons.person),
          ),

          IconButton(
            onPressed: () {
              // Navigate to Favorite Foods Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteFoodsPage(user: _updatedUser),
                ),
              );
            },
            icon: Icon(Icons.fastfood),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome, ${_updatedUser.name}'),
          // Add your UI for profile and favorite food here
        ],
      ),
    );
  }

  // Function to fetch updated user details
  Future<void> _fetchUserDetails() async {
    AppUser? userDetails =
        await FirebaseAuthService().getUserDetails(widget.user.uid);

    if (userDetails != null) {
      // Update the state with the new user details
      setState(() {
        _updatedUser = userDetails;
      });
    } else {
      // Show error message if user details couldn't be fetched
      print("Error fetching user details.");
    }
  }
}