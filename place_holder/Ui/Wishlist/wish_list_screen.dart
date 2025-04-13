import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Auth/Login_screen.dart';
import '../Home/Home_screen.dart'; 
import 'package:londri/place_holder/Ui/profile/profile_screen.dart';

class WishListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // back button
        Get.offAll(HomeScreen());
        return false; 
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Choose Your Nearest Shop',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Get.to(LoginScreen());
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search by nearest location',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              // Header Section
              SizedBox(height: 20),
              // Row for service icons (ListView)
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        // Add action for tapping the card
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
                                    top: 10, // Position the icon at the top-right corner
                                    child: Icon(
                                      Icons.favorite_border, // Wish icon (heart)
                                      color: Colors.yellow,
                                      size: 30,
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
                                          // Navigate to the ProfileScreen page
                                          Get.to(ProfileScreen());
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

