import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:londri/place_holder/Ui/Navigation_screen.dart';
import 'package:londri/place_holder/Ui/Auth/select_screen_owner_user.dart';
import 'Registation_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailOrContactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isPasswordVisible = false; // To toggle password visibility

  void _login(BuildContext context) async {
    final emailOrContact = _emailOrContactController.text.trim();
    final password = _passwordController.text.trim();

    if (emailOrContact.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Both fields are required!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Query Firestore to find a user with the given email/contact number
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: emailOrContact)
          .get();

      if (userSnapshot.docs.isEmpty) {
        // If no user is found with the given email/contact number
        Get.snackbar(
          'Error',
          'Incorrect email/contact number or password!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Get the user data
      var userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

      // Authenticate the user with Firebase Authentication
      await _auth.signInWithEmailAndPassword(
        email: userData['email'],
        password: password,
      );

      // Navigate to the next screen if login is successful
      Get.to(NavigationMenu());
    } catch (e) {
      // Show error message if authentication fails
      Get.snackbar(
        'Error',
        'Incorrect email/contact number or password!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(() => SelectScreen()); // Navigate to SelectScreen every time
          },
        ),
        title: Text("Login to get service"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),

            // Email/Contact No. TextField
            TextField(
              controller: _emailOrContactController,
              decoration: InputDecoration(
                labelText: 'Email/Contact no.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Password TextField with visibility toggle
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible, // Toggle visibility
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible; // Toggle state
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),

            // Login Button
            ElevatedButton(
              onPressed: () => _login(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blue,
              ),
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),

            // New User? Register and Forgot Password Text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Get.to(ResistationScreen());
                  },
                  child: Text("New Here? Register"),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("Forgot password?"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}