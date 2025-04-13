import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:londri/place_holder/Ui/Wishlist/wish_list_screen.dart';
import 'package:londri/place_holder/Ui/payemnt/my_order.dart';
import 'Home/Home_screen.dart';
import 'notification/notification_screen.dart';

class NavigationMenu extends StatefulWidget {
  NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final controller = Get.put(NavigationController()); // Initialize the controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Ensures smooth floating effect
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 26),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(Iconsax.home, 0), // Home
                _buildNavItem(Iconsax.search_favorite, 1), // Wishlist
                _buildNavItem(Iconsax.notification, 2), // Notifications
                _buildNavItem(Iconsax.shopping_cart, 3), // My Orders
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Obx(
        () => controller.screen[controller.selectedIndex.value], // Display the selected page
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        controller.selectedIndex.value = index; // Update the selected index
      },
      child: Icon(
        icon,
        color: controller.selectedIndex.value == index
            ? Colors.blue // Highlight the selected icon
            : Colors.grey,
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs; // Observable for the selected index
  final screen = [
    HomeScreen(),          // Home Screen
    WishListScreen(),      // Wishlist Screen
    NotificationScreen(),  // Notification Screen
    MyOrder(),             // My Orders Screen
  ];
}