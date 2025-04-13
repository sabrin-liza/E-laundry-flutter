import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Mock data for notifications
  final List<Map<String, String>> notifications = [
    {
      "orderNumber": "12345",
      "status": "Completed",
      "time": "2025-04-12 10:00 AM",
    },
    {
      "orderNumber": "12346",
      "status": "Pending",
      "time": "2025-04-12 11:00 AM",
    },
    {
      "orderNumber": "12347",
      "status": "Placed",
      "time": "2025-04-12 12:00 PM",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: notifications.isEmpty
          ? Center(
              child: Text(
                "No notifications available",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      notification["status"] == "Completed"
                          ? Icons.check_circle
                          : notification["status"] == "Pending"
                              ? Icons.hourglass_empty
                              : Icons.shopping_cart,
                      color: notification["status"] == "Completed"
                          ? Colors.green
                          : notification["status"] == "Pending"
                              ? Colors.orange
                              : Colors.blue,
                    ),
                    title: Text("Order #${notification["orderNumber"]}"),
                    subtitle: Text("Status: ${notification["status"]}"),
                    trailing: Text(
                      notification["time"] ?? "",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }
}