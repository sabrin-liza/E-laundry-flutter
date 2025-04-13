import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'order_confirmation.dart';

class OrderSummaryScreen extends StatefulWidget {
  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid; // Fetch the logged-in user's ID

  double _subtotal = 0.0;
  double _discount = 0.0; // Always 0
  double _deliveryCharge = 20.0; // Delivery charge is always 20

  @override
  void initState() {
    super.initState();
    _calculateSubtotal();
  }

  Future<void> _calculateSubtotal() async {
    if (_userId == null) return;

    try {
      // Fetch items and quantities from `order-item-details` collection
      final orderItemsSnapshot = await _firestore
          .collection('order-item-details')
          .where('userId', isEqualTo: _userId)
          .get();

      double subtotal = 0.0;

      for (var doc in orderItemsSnapshot.docs) {
        final item = doc['item'];
        final quantity = int.parse(doc['quantity']);

        // Fetch price from `price-list` collection
        final priceSnapshot = await _firestore
            .collection('price-list')
            .where('item', isEqualTo: item)
            .get();

        if (priceSnapshot.docs.isNotEmpty) {
          final price = double.parse(priceSnapshot.docs.first['price']);
          subtotal += price * quantity;
        }
      }

      setState(() {
        _subtotal = subtotal;
      });
    } catch (e) {
      print('Error calculating subtotal: $e');
    }
  }

  void _confirmOrder() {
    Get.snackbar(
      'Order Confirmed',
      'Your order has been placed successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Navigate to the order confirmation screen
    Get.to(() => OrderConfirmation());
  }

  @override
  Widget build(BuildContext context) {
    final total = _subtotal + _discount + _deliveryCharge;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  OrderSummaryRow(
                      title: 'Subtotal', amount: '৳ ${_subtotal.toStringAsFixed(2)}'),
                  OrderSummaryRow(
                      title: 'Discount', amount: '৳ ${_discount.toStringAsFixed(2)}'),
                  OrderSummaryRow(
                      title: 'Delivery charge',
                      amount: '৳ ${_deliveryCharge.toStringAsFixed(2)}'),
                  Divider(thickness: 1, color: Colors.grey.shade400),
                  OrderSummaryRow(
                      title: 'Total', amount: '৳ ${total.toStringAsFixed(2)}', isBold: true),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              'Payment mode offline',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.0),
            PaymentOption(title: 'Cash on delivery'),
            Spacer(),
            Container(
              color: Colors.blue, // Background color for the entire section
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.shopping_bag,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _confirmOrder,
                          child: Text("Confirm Order"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrderSummaryRow extends StatelessWidget {
  final String title;
  final String amount;
  final bool isBold;

  const OrderSummaryRow({
    required this.title,
    required this.amount,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            amount,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}

class PaymentOption extends StatelessWidget {
  final String title;

  const PaymentOption({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(value: title, groupValue: null, onChanged: (value) {}),
        Text(title),
      ],
    );
  }
}


