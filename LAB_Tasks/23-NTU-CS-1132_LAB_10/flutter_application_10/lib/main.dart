// main.dart

import 'package:flutter/material.dart';
import 'first_route.dart';
import 'todos_screen.dart';

void main() {
  runApp(const Application10());
}

class Application10 extends StatelessWidget {
  const Application10({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMenu(),
    );
  }
}

// ================= MAIN MENU =================
class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lab - 10: Menu"),
        backgroundColor: Colors.green,
        titleTextStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          Card(
            child: ListTile(
              leading: const Icon(Icons.explore, color: Colors.green),
              title: const Text("First Route"),
              titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              subtitle: const Text("Navigation + Hero Animation"),
              subtitleTextStyle: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FirstRoute(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 14),

          Card(
            child: ListTile(
              leading: const Icon(Icons.list_alt, color: Colors.green),
              title: const Text("Todos Screen"),
              titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              subtitle: const Text("Passing Data Between Screens"),
              subtitleTextStyle: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16,),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TodosScreen(),
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}