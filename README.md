TEAM FEPA
1. MUHAMMAD FADZLI BIN MUHAMMAD SHIHAN (20227581313)
2. NURUL ERINA HANI BINTI RAMLIE (2022865226)
3. PUTERI NUR IZZATI BINTI ZUHAIREE (2022660576)
4. AIMIE ZAFIRAH BINTI ABD SUKOR (2022494792)

**Food Page List**
```
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
```

**Food Page Details**
```
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
```

**User Profile Page**
```
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
```

**Login Page**
```
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
```




--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Opeartion

**Add with firebase Email & Password**
```
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
```

**Sign in With Registered Email And Password**
```
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
```

**Google Sign In & Save Google Data User**
```
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
```

**Get User Details**
```
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
```

**Add Food**
```
  Future<void> addFavoriteFood(String uid, String foodName, String description, double price) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).collection('favoriteFoods').add({
      'foodName': foodName,
      'description': description,
      'price': price,
    });
  }

```

**Get Food Details**
```
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
```
