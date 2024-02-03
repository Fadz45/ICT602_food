import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_602/firebase_auth_service.dart';
import 'package:flutter_602/home_page.dart';
import 'package:flutter_602/user_model.dart';
import 'package:flutter_602/registration_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                User? user = await FirebaseAuthService().signInWithEmailAndPassword(
                  _emailController.text,
                  _passwordController.text,
                );

                if (user != null) {
                  // Fetch user details from Firestore
                  AppUser? userDetails = await FirebaseAuthService().getUserDetails(user.uid);

                  if (userDetails != null) {
                    // Navigate to the home page with actual user details
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage(user: userDetails)),
                    );
                  } else {
                    // Show error message if user details couldn't be fetched
                    print("Error fetching user details.");
                  }
                } else {
                  // Show login error message
                  print("Login failed.");
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Center(
                  child: Text(
                    'Login',
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
            ElevatedButton(
              onPressed: () async {
                User? user = await FirebaseAuthService().signInWithGoogle();

                if (user != null) {
                  // Fetch user details from Firestore
                  AppUser? userDetails = await FirebaseAuthService().getUserDetails(user.uid);

                  if (userDetails != null) {
                    // Navigate to the home page with actual user details
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage(user: userDetails)),
                    );
                  } else {
                    // Show error message if user details couldn't be fetched
                    print("Error fetching user details.");
                  }
                } else {
                  // Show login error message
                  print("Google Sign-In failed.");
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Center(
                  child: Text(
                    'Sign in with Google',
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Center(
                  child: Text(
                    'Register',
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
