import 'package:flutter/material.dart';
import 'confirmation_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String customerName = "";
  String discountCode = "";
  String? errorText;
  String selectedSize = "Small";

  final List<String> pizzaSizes = ["Small", "Medium", "Large", "Party Size"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Flutter Application 09')),
        backgroundColor: Colors.green,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --------------- Task - 01 --------------------
            // Customer Name
            TextField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: "Enter customer name",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                customerName = value;
              },
            ),

            const SizedBox(height: 30),

            // --------------- Task - 02 --------------------
            // Discount Code Validation
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.discount),
                labelText: "Discount Code",
                border: const OutlineInputBorder(),
                errorText: errorText,
              ),
              onChanged: (value) {
                setState(() {
                  discountCode = value;
                  if (value.contains(" ")) {
                    errorText = "Don't use blank spaces";
                  } else {
                    errorText = null;
                  }
                });
              },
            ),

            const SizedBox(height: 30),

            // --------------- Task - 03 --------------------
            // Drop down button for Pizza Size
            DropdownButton<String>(
              value: selectedSize,
              isExpanded: true,
              items: pizzaSizes.map((size) {
                return DropdownMenuItem(value: size, child: Text(size));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSize = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            // --------------- Task - 04 --------------------
            // Display Order Summary
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmationScreen(
                      name: customerName,
                      size: selectedSize,
                    ),
                  ),
                );

                if (result == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Order Confirmed!")),
                  );
                }
              },
              child: const Text("Submit Order"),
            ),
          ],
        ),
      ),
    );
  }
}