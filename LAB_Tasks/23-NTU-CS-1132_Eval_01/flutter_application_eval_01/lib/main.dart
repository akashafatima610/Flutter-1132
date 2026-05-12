import 'package:flutter/material.dart';

void main() {
  runApp(const MyScheduleApp());
}

class MyScheduleApp extends StatefulWidget {
  const MyScheduleApp({super.key});

  @override
  State<MyScheduleApp> createState() => _MyScheduleAppState();
}

class _MyScheduleAppState extends State<MyScheduleApp> {
  bool _isDark = false;

  final List<Map<String, String>> schedule = [
    {
      "time": "8:00 - 9:30 AM",
      "subject": "Flutter Development",
      "room": "Room 201",
    },
    {
      "time": "9:45 - 11:15 AM",
      "subject": "Software Engineering",
      "room": "Room 305",
    },
    {
      "time": "11:30 - 1:00 PM",
      "subject": "Database Systems",
      "room": "Room 102",
    },
    {
      "time": "2:00 - 3:30 PM",
      "subject": "Financial Accounting",
      "room": "Room 410",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
      ),
      darkTheme: ThemeData.dark(),
      home: ScheduleScreen(
        schedule: schedule,
        isDark: _isDark,
        onThemeToggle: () {
          setState(() {
            _isDark = !_isDark;
          });
        },
      ),
    );
  }
}

class ScheduleScreen extends StatelessWidget {
  final List<Map<String, String>> schedule;
  final bool isDark;
  final VoidCallback onThemeToggle;

  const ScheduleScreen({
    super.key,
    required this.schedule,
    required this.isDark,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Schedule"),
        centerTitle: true,
        backgroundColor: Colors.green,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: onThemeToggle,
          ),
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: schedule.length,
        itemBuilder: (context, index) {
          final item = schedule[index];

          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Card(
              color: isDark ? Colors.grey[850] : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Card ${index + 1}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(
                          Icons.access_time, size: 18, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          item["time"]!,
                          style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item["subject"]!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(item["room"]!, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
