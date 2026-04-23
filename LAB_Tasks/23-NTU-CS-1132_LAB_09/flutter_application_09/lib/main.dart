import 'package:flutter/material.dart';
import 'order_screen.dart';

void main() {
  runApp(const Application9());
}

class Application9 extends StatelessWidget {
  const Application9({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Application 09',
      home: OrderScreen(),
    );
  }
}