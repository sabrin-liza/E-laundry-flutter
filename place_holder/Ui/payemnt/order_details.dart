import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetails extends StatefulWidget {
  final String orderId; // Order ID passed from the previous page

  const OrderDetails({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _pickupAddress = '';
  String _deliveryAddress = '';
  String _pickupTime = '';
  String _pickupDate = '';
  String _deliveryTime = '';
  String _deliveryDate = '';
  int _statusIndex = 0; // Tracks the current status index

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    try {
      // Fetch order details from Firestore using the orderId
      final orderSnapshot = await _firestore
          .collection('order-address-details')
          .where('orderId', isEqualTo: widget.orderId)
          .get();

      if (orderSnapshot.docs.isNotEmpty) {
        final orderData = orderSnapshot.docs.first.data();

        setState(() {
          _pickupAddress = orderData['pickupAddress'] ?? '';
          _deliveryAddress = orderData['deliveryAddress'] ?? '';
          _pickupTime = orderData['pickupTime'] ?? '';
          _pickupDate = orderData['pickupDate'] ?? '';
          _deliveryTime = orderData['deliveryTime'] ?? '';
          _deliveryDate = orderData['deliveryDate'] ?? '';
          _statusIndex = orderData['statusIndex'] ?? 0; // Fetch status index from Firestore
        });
      }
    } catch (e) {
      print('Error fetching order details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusList = [
      'Item picked',
      'Item in laundry',
      'Out of laundry',
      'Delivered',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Order Status'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Order Status
            const Text(
              'Order Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < statusList.length; i++)
              Row(
                children: [
                  _statusDot(i <= _statusIndex ? Colors.blue : Colors.grey),
                  Text(
                    statusList[i],
                    style: TextStyle(
                      color: i <= _statusIndex ? Colors.blue : Colors.grey,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 30),

            // Order ID
            Text(
              'Order ID: ${widget.orderId}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Pickup & Delivery
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pickup'),
                Text('$_pickupTime | $_pickupDate'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Delivery'),
                Text('$_deliveryTime | $_deliveryDate'),
              ],
            ),
            const SizedBox(height: 30),

            // Addresses
            Text(
              'Pickup Address\n$_pickupAddress',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Delivery Address\n$_deliveryAddress',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            // Payment Method
            const Text(
              'Payment method: Cash on delivery',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusDot(Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}