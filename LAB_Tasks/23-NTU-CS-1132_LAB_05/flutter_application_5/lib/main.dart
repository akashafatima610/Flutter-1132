import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const Application5());
}

class Application5 extends StatelessWidget {
  const Application5({super.key});

  void playSound(int soundNumber) {
    final player = AudioPlayer();
    player.play(AssetSource('note$soundNumber.wav'));
  }

  Expanded buildKey({required int soundNumber, required Color color}) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: color),
        onPressed: () {
          playSound(soundNumber);
        },
        child: Text(
          "Note$soundNumber",
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Flutter LAB - 05")),
          backgroundColor: Colors.green,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildKey(soundNumber: 1, color: Colors.red),
            buildKey(soundNumber: 2, color: Colors.orange),
            buildKey(soundNumber: 3, color: Colors.yellow),
            buildKey(soundNumber: 4, color: Colors.green),
            buildKey(soundNumber: 5, color: Colors.blue),
            buildKey(soundNumber: 6, color: Colors.indigo),
            buildKey(soundNumber: 7, color: Colors.purple),
          ],
        ),
      ),
    );
  }
}