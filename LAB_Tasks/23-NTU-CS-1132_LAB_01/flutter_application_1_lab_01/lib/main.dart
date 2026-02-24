import 'package:flutter/material.dart';

void main() {
  runApp(MyFlutterApp());
}

class MyFlutterApp extends StatelessWidget {
  const MyFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Flutter LAB - 01'),),
          backgroundColor: Colors.greenAccent,
        ),

        // body: Column(
        //   children: [
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text
        //         (
        //           'Student Name: ',
        //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //         ),
        //       ],
        //     ),

        //     const SizedBox(height: 20),   // setting spacing by sized boxes

        //     const Center(
        //       child: Text(
        //         'Akasha Fatima - AF06',
        //         style: TextStyle(fontSize: 18),
        //         ),
        //     )
        //   ],
        // ),

        body: Center
        (
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/ntu_logo.png',
                height: 200,
                ),

                const SizedBox(height: 20),

                Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3kk8pfaxcfCiHYKtzzyi45Wfon2SYDI0dPw&s',
                    height: 200
                )
            ],
          ),
        ),
      ),
    );
  }
}