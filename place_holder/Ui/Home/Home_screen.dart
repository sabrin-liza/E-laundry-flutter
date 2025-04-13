import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Auth/Login_screen.dart';
import '../profile/Profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _fullName = "Loading...";
  String _address = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    // Get the currently logged-in user
    User? user = _auth.currentUser;

    if (user != null) {
      // Fetch user data from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          _fullName = userDoc['fullName'] ?? "No Name";
          _address = userDoc['address'] ?? "No Address";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.location_on), // Location icon
          onPressed: () {
            // Add your action here
          },
        ),
        title: Text(
          '$_fullName\n$_address',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _auth.signOut(); // Log out the user
              Get.offAll(LoginScreen()); // Navigate to LoginScreen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Welcome to Bachelor\'s Point!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Choose the service you want to get today',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ServiceCard(
                          image: "assets/images/dry.png",
                          label: "Dry Clean",
                        ),
                        ServiceCard(
                          image: "assets/images/laundry.png",
                          label: "Laundry",
                        ),
                        ServiceCard(
                          image: "assets/images/ironing.png",
                          label: "Iron",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // List of services or other content
              Container(
                height: 500, // Explicit height for ListView
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(ProfileScreen()); // Navigate to ProfileScreen
                      },
                      child: Container(
                        height: 300,
                        margin: EdgeInsets.only(bottom: 16), // Add margin between cards
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                    child: Image.asset(
                                      "assets/images/Rectangle 781.png", // Replace with your image
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    bottom: 10,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        // Rating section with blue background
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.star, color: Colors.yellow, size: 20),
                                              Text("4.2", style: TextStyle(fontSize: 16, color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        // Reviews section with white background
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            "254 Reviews",
                                            style: TextStyle(fontSize: 14, color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Lavendar Laundry",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.location_on, size: 18),
                                            SizedBox(width: 5),
                                            Text("Shop 1 km away"),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.access_time, size: 18),
                                            SizedBox(width: 5),
                                            Text("Delivery period 24-72 Hour"),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.to(ProfileScreen()); // Navigate to ProfileScreen
                                        },
                                        child: Text('Book'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String image;
  final String label;

  ServiceCard({required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            image,
            width: 80,
            height: 80,
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}









