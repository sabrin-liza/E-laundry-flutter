import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'order_details.dart'; // Import the OrderDetails page

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid; // Fetch the logged-in user's ID
  List<Map<String, dynamic>> orders = []; // List to store fetched orders

  @override
  void initState() {
    super.initState();
    _fetchOrders(); // Fetch orders from Firestore
  }

  Future<void> _fetchOrders() async {
    if (_userId == null) return; // If user ID is null, return early

    try {
      // Fetch orders from `order-item-details` collection where userId matches
      final snapshot = await _firestore
          .collection('order-item-details')
          .where('userId', isEqualTo: _userId)
          .get();

      // Map the fetched data to the orders list
      final fetchedOrders = snapshot.docs.map((doc) {
        return {
          'orderId': doc['orderId'],
          'service': doc['service'],
          'item': doc['item'],
          'quantity': doc['quantity'],
        };
      }).toList();

      setState(() {
        orders = fetchedOrders; // Update the orders list
      });
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(); // Navigate back to the previous screen
          },
        ),
      ),
      body: orders.isEmpty
          ? Center(child: Text('No orders found.')) // Show message if no orders
          : ListView.builder(
              itemCount: orders.length, // Dynamically render based on the number of orders
              itemBuilder: (context, index) {
                final order = orders[index]; // Get the current order
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 8,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${order['orderId']} | ${order['quantity']} pcs',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            order['service'],
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Item: ${order['item']}',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to OrderDetails page with the orderId
                                  Get.to(() => OrderDetails(orderId: order['orderId']));
                                },
                                child: Text('Check Status'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}