// first_route.dart

import 'package:flutter/material.dart';
import 'second_route.dart';

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('First Screen : LAB - 10')),
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
              child: Text('Go to Second Screen'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondRoute()),
                );
              },
            ),

            Divider(height: 40, thickness: 2, color: Colors.green),

            // --------------- Task 02 ------------------
            Text(
              'Implementing Hero Animations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 30),

            GestureDetector(
              child: Hero(
                tag: 'profile-image',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAVKu9ltsW2BFG3T68866tsR2nCeKF-hQTgQ&s',
                  height: 200,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondRoute()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
