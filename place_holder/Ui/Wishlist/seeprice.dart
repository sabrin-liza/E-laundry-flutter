import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../profile/profile_screen.dart'; 

class SeePrice extends StatefulWidget {
  const SeePrice({super.key});

  @override
  State<SeePrice> createState() => _SeePriceState();
}

class _SeePriceState extends State<SeePrice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back button icon
          onPressed: () {
            Get.to(ProfileScreen()); // Navigate to ProfileScreen
          },
        ),
        title: Text('Service Pricing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
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
                label: Text('Wash and Iron'),
              ),
              DataColumn(
                label: Text('Dry Clean'),
              ),
            ],
            rows: const <DataRow>[
              DataRow(cells: [
                DataCell(Text('Apron')),
                DataCell(Text('12')),
                DataCell(Text('60')),
                DataCell(Text('90')),
              ]),
              DataRow(cells: [
                DataCell(Text('Baby Dress')),
                DataCell(Text('12')),
                DataCell(Text('50')),
                DataCell(Text('80')),
              ]),
              DataRow(cells: [
                DataCell(Text('Bed Sheet')),
                DataCell(Text('30')),
                DataCell(Text('90')),
                DataCell(Text('140')),
              ]),
              DataRow(cells: [
                DataCell(Text('Blanket')),
                DataCell(Text('-')),
                DataCell(Text('200')),
                DataCell(Text('400')),
              ]),
              DataRow(cells: [
                DataCell(Text('Blazer/Coat')),
                DataCell(Text('200')),
                DataCell(Text('200')),
                DataCell(Text('280')),
              ]),
              DataRow(cells: [
                DataCell(Text('Blouse')),
                DataCell(Text('12')),
                DataCell(Text('60')),
                DataCell(Text('90')),
              ]),
              DataRow(cells: [
                DataCell(Text('Burkha')),
                DataCell(Text('20')),
                DataCell(Text('120')),
                DataCell(Text('180')),
              ]),
              DataRow(cells: [
                DataCell(Text('Chador ')),
                DataCell(Text('20')),
                DataCell(Text('120')),
                DataCell(Text('180')),
              ]),
              DataRow(cells: [
                DataCell(Text('Churidar')),
                DataCell(Text('20')),
                DataCell(Text('120')),
                DataCell(Text('180')),
              ]),
              DataRow(cells: [
                DataCell(Text('Coat')),
                DataCell(Text('200')),
                DataCell(Text('200')),
                DataCell(Text('280')),
              ]),
              DataRow(cells: [
                DataCell(Text('Curtain')),
                DataCell(Text('20')),
                DataCell(Text('120')),
                DataCell(Text('180')),
              ]),
              DataRow(cells: [
                DataCell(Text('Duppata')),
                DataCell(Text('20')),
                DataCell(Text('120')),
                DataCell(Text('180')),
              ]),
              DataRow(cells: [
                DataCell(Text('Frock')),
                DataCell(Text('12')),
                DataCell(Text('60')),
                DataCell(Text('90')),
              ]),
              DataRow(cells: [
                DataCell(Text('Gown')),
                DataCell(Text('20')),
                DataCell(Text('120')),
                DataCell(Text('180')),
              ]),
              DataRow(cells: [
                DataCell(Text('Jeans')),
                DataCell(Text('20')),
                DataCell(Text('120')),
                DataCell(Text('180')),
              ]),
              DataRow(cells: [
                DataCell(Text('Jacket')),
                DataCell(Text('20')),
                DataCell(Text('120')),
                DataCell(Text('180')),
              ]),
              DataRow(cells: [
                DataCell(Text('Kurta')),
                DataCell(Text('20')),
                DataCell(Text('120')),
                DataCell(Text('180')),
              ]),
              DataRow(cells: [
                DataCell(Text('Pant')),
                DataCell(Text('20')),
                DataCell(Text('40')),
                DataCell(Text('50')),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}