import 'package:flutter/material.dart';

void main() {
  runApp(Application6());
}

class Application6 extends StatefulWidget {
  const Application6  ({super.key});

  @override
  State<Application6> createState() => _Application6State();
}

class _Application6State extends State<Application6> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ---------------------- Task - 01 (dark mode)----------------
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Center(child: Text("Flutter LAB - 06")),
              backgroundColor: Colors.green,
              titleTextStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
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
              padding: EdgeInsets.all(20),
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
                  SizedBox(height: 30),

                  // ---------------------- Task - 03 (Card) ----------------------
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "This is a themed card widget. Its design changes automatically based on light and dark mode.",
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Themed Button"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  final lightTheme = ThemeData(
    brightness: Brightness.light,
    cardTheme: CardThemeData(
      color: Colors.white,
      shadowColor: Colors.grey,
      elevation: 5,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 18, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
    ),
  );

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    cardTheme: CardThemeData(
      color: Colors.grey[800],
      shadowColor: Colors.black,
      elevation: 5,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
    ),
  );
}