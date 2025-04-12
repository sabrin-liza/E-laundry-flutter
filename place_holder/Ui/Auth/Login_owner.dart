import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../owner/owner_screen.dart';
import 'Registation_owner.dart';

class LoginScreenOwner extends StatelessWidget {
  final TextEditingController _emailOrContactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      // Authenticate the user with Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailOrContact,
        password: password,
      );

      // Check if the user exists in the Firestore 'owners' collection
      DocumentSnapshot ownerDoc = await _firestore
          .collection('owners')
          .doc(userCredential.user!.uid)
          .get();

      if (ownerDoc.exists) {
        // Navigate to the OwnerScreen if login is successful
        Get.to(() => OwenerScreen());
      } else {
        // If the user is not found in the 'owners' collection
        Get.snackbar(
          'Error',
          'Incorrect information provided!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
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
        title: Text("Login to manage your shop"),
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

            // Password TextField
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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
                    Get.to(() => ResistationScreenOwner()); // Navigate to Registration Screen
                  },
                  child: Text("New Here? Register"),
                ),
                TextButton(
                  onPressed: () {
                    // Add forgot password logic here
                  },
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