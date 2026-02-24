import 'package:flutter/material.dart';

void main() {
  runApp(Application3());
}
class Application3 extends StatelessWidget {
  const Application3 ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Flutter LAB - 03")),
          backgroundColor: Colors.green,
          titleTextStyle:TextStyle(fontSize: 24, fontWeight: FontWeight.bold) ,
        ),

        body: Center(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              // card 1
              Card(
                color: Colors.redAccent,
                elevation: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.home, size: 40, color: Colors.blue),
                    Icon(Icons.favorite, size: 40, color: Colors.yellow),
                    Icon(Icons.settings, size: 40, color: Colors.black),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // card 2
              Card(
                color: Colors.greenAccent,
                elevation: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.star, size: 40, color: Colors.orange),
                    SizedBox(height: 30),
                    Icon(Icons.person, size: 40, color: Colors.grey),
                    SizedBox(height: 30),
                    Icon(Icons.phone, size: 40, color: Colors.teal),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // card 3
              Card(
                color: Colors.yellow,
                elevation: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.email, size: 40, color: Colors.indigo),
                    Icon(Icons.camera, size: 40, color: Colors.pink),
                    Icon(Icons.map, size: 40, color: Colors.brown),
                  ],
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}