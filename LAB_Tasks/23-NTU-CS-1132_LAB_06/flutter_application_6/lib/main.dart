import 'package:flutter/material.dart';

void main() {
  runApp(Application5());
}

class Application5 extends StatefulWidget {
  const Application5({super.key});

  @override
  State<Application5> createState() => _Application5State();
}

class _Application5State extends State<Application5> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ---------------------- Task - 01 (dark mode)----------------
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Flutter LAB - 05")),
          backgroundColor: Colors.green,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          centerTitle: true,
          actions: [
            Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
          ],
        ),

        body: Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: Column(
            children: [
              // ---------------------- Task - 02 (ThemeData Class on paragraphs)----------------
              Text(
                "Software engineering plays a vital role in modern application development. "
                "It ensures that applications are efficient, scalable, and maintainable.",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),

              Text(
                "Flutter allows developers to build cross-platform applications with a single codebase. "
                "It provides a rich set of UI components and high performance.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),

            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------- Light Theme ----------------
final lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.green,
    titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 18, color: Colors.purple),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.purpleAccent),
  ),
);

// ---------------------- Dark Theme ----------------
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.green,
    titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 18, color: Colors.yellow),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.yellowAccent),
  ),
);