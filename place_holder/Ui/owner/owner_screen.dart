import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math'; // Import for generating random numbers
import 'package:londri/place_holder/Ui/Auth/Login_owner.dart'; // Correct import for LoginScreenOwner
import '../test.dart'; // Import the Test page

class OwenerScreen extends StatelessWidget {
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _deliveryChargeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _selectedService; // Variable to store the selected service
  String? _selectedItem; // Variable to store the selected item

  Future<void> _addAreaAndDeliveryCharge(BuildContext context) async {
    final area = _areaController.text.trim();
    final deliveryCharge = _deliveryChargeController.text.trim();

    if (area.isEmpty || deliveryCharge.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill both Area and Delivery Charge fields!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Check if the area already exists in Firestore
      final existingArea = await _firestore
          .collection('area-charge')
          .where('area', isEqualTo: area)
          .get();

      if (existingArea.docs.isNotEmpty) {
        Get.snackbar(
          'Error',
          'This area is already taken. Please use a different area!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Generate a random 8-digit ID
      final randomId = _generateRandomId();

      // Save the data to Firestore
      await _firestore.collection('area-charge').doc(randomId).set({
        'area': area,
        'deliveryCharge': deliveryCharge,
      });

      Get.snackbar(
        'Success',
        'Area and Delivery Charge added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear the fields after successful addition
      _areaController.clear();
      _deliveryChargeController.clear();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add Area and Delivery Charge. Please try again!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _addServiceItem(BuildContext context) async {
    final service = _selectedService;
    final item = _selectedItem;
    final price = _priceController.text.trim();

    if (service == null || item == null || price.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields before adding!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Check if the combination of service and item already exists in Firestore
      final existingEntry = await _firestore
          .collection('price-list')
          .where('service', isEqualTo: service)
          .where('item', isEqualTo: item)
          .get();

      if (existingEntry.docs.isNotEmpty) {
        Get.snackbar(
          'Error',
          'This service and item combination already exists. Please use a different combination!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Generate a random 8-digit unique ID
      final randomId = _generateRandomId();

      // Save the data to Firestore
      await _firestore.collection('price-list').doc(randomId).set({
        'service': service,
        'item': item,
        'price': price,
      });

      Get.snackbar(
        'Success',
        'Service and Item added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear the fields after successful addition
      _selectedService = null;
      _selectedItem = null;
      _priceController.clear();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add Service and Item. Please try again!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _generateRandomId() {
    final random = Random();
    return (10000000 + random.nextInt(90000000)).toString(); // Generate an 8-digit random number
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
          'Lavender Shop\nKhagan, Ashulia, Savar, Dhaka',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Get.to(() => LoginScreenOwner()); // Navigate to LoginScreenOwner
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
                    Text(
                      'Welcome to Bachelor\'s Point!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Manage your shop with our app',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Row for service icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image(
                    image: AssetImage("assets/images/image 41.png"),
                    width: 40,
                    height: 40,
                  ),
                  Image(
                    image: AssetImage("assets/images/image 42.png"),
                    width: 40,
                    height: 40,
                  ),
                  Image(
                    image: AssetImage("assets/images/image 40.png"),
                    width: 40,
                    height: 40,
                  ),
                  Image(
                    image: AssetImage("assets/images/image 45.png"),
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Area Field
              TextField(
                controller: _areaController,
                decoration: InputDecoration(
                  labelText: 'Area',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Delivery Charge Field
              TextField(
                controller: _deliveryChargeController,
                decoration: InputDecoration(
                  labelText: 'Delivery Charge',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Add Area and Delivery Charge Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _addAreaAndDeliveryCharge(context); // Add Area and Delivery Charge logic
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Add Area and Delivery Charge",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Service Dropdown
              DropdownButtonFormField<String>(
                value: _selectedService,
                decoration: InputDecoration(
                  labelText: 'Service',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: ['Iron', 'Wash & Iron', 'Dry Clean']
                    .map((service) => DropdownMenuItem<String>(
                          value: service,
                          child: Text(service),
                        ))
                    .toList(),
                onChanged: (value) {
                  _selectedService = value;
                },
              ),
              SizedBox(height: 20),

              // Item Dropdown
              DropdownButtonFormField<String>(
                value: _selectedItem,
                decoration: InputDecoration(
                  labelText: 'Item',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: [
                  'Pant',
                  'Shirt',
                  'Blazer',
                  'Apron',
                  'Blanket',
                  'Saree',
                  'Coat',
                  'Jacket'
                ]
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                onChanged: (value) {
                  _selectedItem = value;
                },
              ),
              SizedBox(height: 20),

              // Price Field
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Add Service and Item Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _addServiceItem(context); // Add Service and Item logic
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Add Service and Item",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Bottom navigation bar with icons (fixed at the bottom)
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Get.to(() => Pricelist()); // Navigate to Test page when Icon.list is tapped
          }
        },
      ),
    );
  }
}