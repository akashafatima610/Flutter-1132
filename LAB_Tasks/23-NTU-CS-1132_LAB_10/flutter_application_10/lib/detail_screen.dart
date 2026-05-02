// detail_screen.dart

import 'package:flutter/material.dart';
import 'todo.dart';

class DetailScreen extends StatelessWidget {
  final Todo todo;

  const DetailScreen({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              todo.description,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}