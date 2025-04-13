import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Pricelist extends StatefulWidget {
  const Pricelist({super.key});

  @override
  State<Pricelist> createState() => _PricelistState();
}

class _PricelistState extends State<Pricelist> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to fetch data from Firestore
  Future<List<Map<String, dynamic>>> _fetchPriceList() async {
    try {
      final querySnapshot = await _firestore.collection('price-list').get();
      final List<Map<String, dynamic>> priceList = [];

      for (var doc in querySnapshot.docs) {
        priceList.add(doc.data());
      }

      return priceList;
    } catch (e) {
      print('Error fetching price list: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laundry Services'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchPriceList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error fetching data'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            }

            final priceList = snapshot.data!;
            final Map<String, Map<String, String>> itemPrices = {};

            // Organize data by item and service
            for (var entry in priceList) {
              final item = entry['item'] ?? 'Unknown';
              final service = entry['service'] ?? 'Unknown';
              final price = entry['price'] ?? '-';

              if (!itemPrices.containsKey(item)) {
                itemPrices[item] = {
                  'Iron': '-',
                  'Wash & Iron': '-',
                  'Dry Clean': '-',
                };
              }

              itemPrices[item]![service] = price;
            }

            // Build rows for the DataTable
            final rows = itemPrices.entries.map((entry) {
              final item = entry.key;
              final prices = entry.value;

              return DataRow(cells: [
                DataCell(Text(item)),
                DataCell(Text(prices['Iron'] ?? '-')),
                DataCell(Text(prices['Wash & Iron'] ?? '-')),
                DataCell(Text(prices['Dry Clean'] ?? '-')),
              ]);
            }).toList();

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text('Item'),
                  ),
                  DataColumn(
                    label: Text('Iron'),
                  ),
                  DataColumn(
                    label: Text('Wash & Iron'),
                  ),
                  DataColumn(
                    label: Text('Dry Clean'),
                  ),
                ],
                rows: rows,
              ),
            );
          },
        ),
      ),
    );
  }
}






