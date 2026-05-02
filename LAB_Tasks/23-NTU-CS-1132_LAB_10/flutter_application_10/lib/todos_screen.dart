// todo_screen.dart

import 'package:flutter/material.dart';
import 'todo.dart';
import 'detail_screen.dart';

class TodosScreen extends StatelessWidget {
  TodosScreen({super.key});

  final List<Todo> todos = [
    Todo(
      title: "Buy Groceries",
      description: "Milk, Eggs, Bread, Fruits",
    ),
    Todo(
      title: "Study Flutter",
      description: "Complete navigation and data passing task",
    ),
    Todo(
      title: "Playing Games",
      description: "Play Homescape for 1 hour",
    ),
    Todo(
      title: "Watching Documentary",
      description: "History of economically growth countries",
    ),
    Todo(
      title: "Baking",
      description: "Make a cake and pastries for the gathering",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Todos List")),
        backgroundColor: Colors.green,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold
      ),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];

          return ListTile(
            title: Text(todo.title),
            titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
            leading: const Icon(Icons.task, color: Colors.green),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(todo: todo),
                ),
              );
            },
          );
        },
      ),
    );
  }
}