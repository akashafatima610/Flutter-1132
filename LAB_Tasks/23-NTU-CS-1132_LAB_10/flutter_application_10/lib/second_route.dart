// second_route.dart

import 'package:flutter/material.dart';

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Second Screen : LAB - 10')),
        backgroundColor: Colors.green,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // --------------- Task 01 ------------------
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 8,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              child: Text("Go Back"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            Divider(height: 40, thickness: 2, color: Colors.green),

            // --------------- Task 02 ------------------
            Text(
              'Implementing Hero Animations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 30),

            Hero(
              tag: 'profile-image',
              child: Material(
                // 🔥 IMPORTANT FIX
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAVKu9ltsW2BFG3T68866tsR2nCeKF-hQTgQ&s',
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
