import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


import 'package:flutter_602/food_model.dart';
import 'package:flutter_602/user_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error during registration: $e");
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        // Google sign-in canceled by the user
        return null;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      await _saveGoogleUserDataToFirestore(authResult.user!);
      return authResult.user;
    } catch (e) {
      print("Error during Google sign-in: $e");
      return null;
    }
  }

  Future<void> _saveGoogleUserDataToFirestore(User user) async {
    // Check if the user already exists in Firestore
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (!userDoc.exists) {
      // If the user does not exist, save their details to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': user.displayName,
        'email': user.email,
        // Add other user details as needed
      });
    }
  }

  // FirebaseAuthService
  Future<AppUser?> getUserDetails(String uid) async {
    try {
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          return AppUser(
            uid: uid,
            email: firebaseUser.email ?? "",
            name: userDoc.data()?['name'] ?? "",
            age: userDoc.data()?['age'] ?? 0,
          );
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }

  Future<void> updateUserProfile(String uid, String name, int age) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': name,
        'age': age,
      });
    } catch (e) {
      print("Error updating user profile: $e");
      throw e; // Propagate the error back to the caller
    }
  }


  Future<void> addFavoriteFood(String uid, String foodName, String description, double price) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).collection('favoriteFoods').add({
      'foodName': foodName,
      'description': description,
      'price': price,
    });
  }

  Future<List<Food>> getFavoriteFoods(String uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> foodDocs = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('favoriteFoods')
          .get();

      return foodDocs.docs.map((foodDoc) {
        return Food(
          name: foodDoc.data()?['foodName'] ?? "",
          description: foodDoc.data()?['description'] ?? "",
          price: foodDoc.data()?['price'] ?? 0.0,
        );
      }).toList();
    } catch (e) {
      print("Error fetching favorite foods: $e");
      return [];
    }
  }
}