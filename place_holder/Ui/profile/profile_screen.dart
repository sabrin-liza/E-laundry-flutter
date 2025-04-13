import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import '../Wishlist/seeprice.dart';
import '../payemnt/payment_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<Map<String, dynamic>> _rows = []; // List to store rows dynamically

  final TextEditingController _pickupAddressController = TextEditingController();
  final TextEditingController _pickupDateController = TextEditingController();
  final TextEditingController _pickupTimeController = TextEditingController();
  final TextEditingController _deliveryAddressController = TextEditingController();
  final TextEditingController _additionalInstructionsController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _userId; // Variable to store the logged-in user's ID
  String? _orderId; // Variable to store the generated order ID

  @override
  void initState() {
    super.initState();
    _fetchUserId(); // Fetch the last logged-in user's ID
    _addRow(); // Add an initial row
  }

  void _fetchUserId() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid; // Fetch and store the logged-in user's ID
      });
    }
  }

  void _addRow() {
    // Validate the last row before adding a new row
    if (_rows.isNotEmpty) {
      final lastRow = _rows.last;
      if (lastRow['service'] == null ||
          lastRow['item'] == null ||
          lastRow['quantity'].text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Please fill all fields in the previous row before adding a new row!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    }

    setState(() {
      _rows.add({
        'service': null,
        'item': null,
        'quantity': TextEditingController(),
      });
    });
  }

  void _removeRow(int index) {
    setState(() {
      _rows.removeAt(index);
    });
  }

  Future<bool> _saveOrderItemsToFirestore() async {
    if (_rows.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one row before saving!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      if (_userId == null) {
        Get.snackbar(
          'Error',
          'Failed to fetch user ID. Please log in again!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Generate a unique 4-digit order ID
      _orderId = (1000 + (DateTime.now().millisecondsSinceEpoch % 9000)).toString();

      for (var row in _rows) {
        if (row['service'] == null || row['item'] == null || row['quantity'].text.trim().isEmpty) {
          Get.snackbar(
            'Error',
            'Please fill all fields in every row before saving!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }

        // Save the data to the `order-item-details` collection
        await _firestore.collection('order-item-details').add({
          'orderId': _orderId, // Save the generated order ID
          'userId': _userId, // Save the logged-in user's ID
          'service': row['service'],
          'item': row['item'],
          'quantity': row['quantity'].text.trim(),
          'timestamp': FieldValue.serverTimestamp(), // Add a timestamp
        });
      }

      Get.snackbar(
        'Success',
        'Items saved successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true; // Return true if data is saved successfully
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save items. Please try again!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false; // Return false if an error occurs
    }
  }

  Future<bool> _saveOrderAddressToFirestore() async {
    if (_pickupAddressController.text.trim().isEmpty ||
        _pickupDateController.text.trim().isEmpty ||
        _pickupTimeController.text.trim().isEmpty ||
        _deliveryAddressController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all required fields before proceeding!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false; // Return false if validation fails
    }

    try {
      if (_userId == null || _orderId == null) {
        Get.snackbar(
          'Error',
          'Failed to fetch user ID or order ID. Please log in again!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Save the data to the `order-address-details` collection
      await _firestore.collection('order-address-details').add({
        'orderId': _orderId, // Save the generated order ID
        'userId': _userId, // Save the logged-in user's ID
        'pickupAddress': _pickupAddressController.text.trim(),
        'pickupDate': _pickupDateController.text.trim(),
        'pickupTime': _pickupTimeController.text.trim(),
        'deliveryAddress': _deliveryAddressController.text.trim(),
        'additionalInstructions': _additionalInstructionsController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(), // Add a timestamp
      });

      Get.snackbar(
        'Success',
        'Address saved successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true; // Return true if data is saved successfully
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save address. Please try again!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false; // Return false if an error occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back button icon
          onPressed: () {
            Get.back(); // Navigate back to the previous screen
          },
        ),
        title: Text(
          'Lavendar Shop\nKhagan, Ashulia, Savar, Dhaka',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: 150,
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/images/WhatsApp Image 2025-03-26 at 14.30.31_c782bf28 1.png"),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Lavendar Laundry",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Khagan,\n Ashulia, Savar, Dhaka",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Dynamic Rows for Select Service, Select Item, and Quantity
              Column(
                children: _rows.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> row = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: [
                        // Select Service Dropdown
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Service',
                              labelStyle: TextStyle(fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: ['Iron', 'Wash and Iron', 'Dry Clean']
                                .map((service) => DropdownMenuItem<String>(
                                      value: service,
                                      child: Text(service, style: TextStyle(fontSize: 14)),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              row['service'] = value;
                            },
                          ),
                        ),
                        SizedBox(width: 10),

                        // Select Item Dropdown
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Item',
                              labelStyle: TextStyle(fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: ['Shirt', 'Pant', 'T-shirt', 'Saree', 'Shalwar', 'Jacket']
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item, style: TextStyle(fontSize: 14)),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              row['item'] = value;
                            },
                          ),
                        ),
                        SizedBox(width: 10),

                        // Quantity Input Field
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: row['quantity'],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Qty',
                              labelStyle: TextStyle(fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),

                        // Remove Row Button
                        IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            _removeRow(index);
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              // Add Row Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: _addRow,
                  icon: Icon(Icons.add),
                  label: Text("Add Row"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // OK Button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final isSaved = await _saveOrderItemsToFirestore(); // Save the rows' data to Firestore
                    if (isSaved) {
                      Get.snackbar(
                        'Success',
                        'Items saved successfully!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Pickup Address Field
              TextField(
                controller: _pickupAddressController,
                decoration: InputDecoration(
                  labelText: 'Pickup Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Pickup Date Field
              TextField(
                controller: _pickupDateController,
                decoration: InputDecoration(
                  labelText: 'Pickup Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Pickup Time Field
              TextField(
                controller: _pickupTimeController,
                decoration: InputDecoration(
                  labelText: 'Pickup Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Delivery Address Field
              TextField(
                controller: _deliveryAddressController,
                decoration: InputDecoration(
                  labelText: 'Delivery Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Additional Instructions Field
              TextField(
                controller: _additionalInstructionsController,
                decoration: InputDecoration(
                  labelText: 'Additional Instructions',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Proceed Button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final isSaved = await _saveOrderAddressToFirestore(); // Save the address data to Firestore
                    if (isSaved) {
                      Get.to(() => OrderSummaryScreen()); // Navigate to the PaymentScreen only if data is saved
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Proceed",
                    style: TextStyle(color: Colors.white, fontSize: 16),
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