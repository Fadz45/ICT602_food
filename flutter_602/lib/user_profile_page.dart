// user_profile_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_602/user_model.dart';

class UserProfilePage extends StatelessWidget {
  final AppUser user;

  UserProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Email: ${user.email}'),
          Text('Name: ${user.name}'),
          Text('Age: ${user.age}'),
          // Add more user profile details if needed
        ],
      ),
    );
  }
}

