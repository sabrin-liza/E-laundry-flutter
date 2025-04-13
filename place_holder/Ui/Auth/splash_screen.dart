import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:londri/place_holder/Ui/Auth/select_screen_owner_user.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.blue,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title at the top
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: Text(
                  "Bachelor's Point",
                  style: TextStyle(
                    fontSize: screenWidth * 0.07, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              // Logo in the center
              Applogo(
                height: screenHeight * 0.4, // Adjust logo height dynamically
                width: screenWidth * 0.6, // Adjust logo width dynamically
              ),
              // Get Started button at the bottom
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => SelectScreen()); // Navigate to SelectScreen
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1, // Button width based on screen size
                      vertical: screenHeight * 0.02, // Button height based on screen size
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045, // Responsive font size
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Applogo extends StatelessWidget {
  const Applogo({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/splash.png",
      height: height ?? MediaQuery.of(context).size.height * 0.65,
      width: width ?? MediaQuery.of(context).size.width * 0.6,
      fit: BoxFit.contain,
    );
  }
}
