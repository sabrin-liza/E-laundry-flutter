import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:londri/place_holder/Ui/Auth/Login_owner.dart';
import 'Login_screen.dart';

class SelectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        title: Text(
          "Bachelor's Point",
          style: TextStyle(fontSize: screenWidth * 0.05), // Responsive font size
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First Button with text "Need Laundry Service?"
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: screenHeight * 0.03),
                child: Column(
                  children: [
                    Text(
                      'Need Laundry Service?',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045, // Responsive font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), // Responsive spacing
                    Container(
                      width: screenWidth * 0.5, // Responsive button width
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(LoginScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Get service",
                          style: TextStyle(fontSize: screenWidth * 0.04), // Responsive font size
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Second Button with text "Want to Offer Laundry Service?"
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: screenHeight * 0.03),
                child: Column(
                  children: [
                    Text(
                      'Want to Offer Laundry Service?',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045, // Responsive font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), // Responsive spacing
                    Container(
                      width: screenWidth * 0.5, // Responsive button width
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(LoginScreenOwner());
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Give Service",
                          style: TextStyle(fontSize: screenWidth * 0.04), // Responsive font size
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
  }
}