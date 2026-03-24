import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const Application7());
}

class Application7 extends StatefulWidget {
  const Application7({super.key});

  @override
  State<Application7> createState() => _Application7State();
}

class _Application7State extends State<Application7> {
  // Phase - 01: GestureDetector
  Color boxColor = Colors.blue;
  double borderRadius = 0;

  void resetBox() {
    setState(() {
      boxColor = Colors.blue;
      borderRadius = 0;
    });
  }

  // Phase - 02: Sliders
  double sliderValue = 50;

  // Phase - 03: Mood & Color Mixer
  double red = 100;
  double green = 100;
  double blue = 100;
  double boxSize = 150;

  Color get mixedColor =>
      Color.fromRGBO(red.toInt(), green.toInt(), blue.toInt(), 1);

  String get hexCode =>
      '#${red.toInt().toRadixString(16).padLeft(2, '0')}${green.toInt().toRadixString(16).padLeft(2, '0')}${blue.toInt().toRadixString(16).padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Flutter LAB - 07")),
          backgroundColor: Colors.green,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          centerTitle: true,
        ),

        body: Builder(
          builder: (context) => SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ---------------- Task - 01 ----------------
                  Text(
                    "Phase - 01: GestureDetector",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        boxColor =
                            Colors.primaries[Random().nextInt(
                              Colors.primaries.length,
                            )];
                      });
                    },
                    onDoubleTap: () {
                      setState(() {
                        borderRadius = borderRadius == 0 ? 100 : 0;
                      });
                    },
                    onLongPress: () {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Resetting...")));
                      resetBox();
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),
                  // ---------------- Task - 02 ----------------
                  Text(
                    "Phase - 02: Sliders",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text("Value: ${sliderValue.toStringAsFixed(1)}"),
                  Slider(
                    value: sliderValue,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: sliderValue.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        sliderValue = value;
                      });
                    },
                  ),

                  CupertinoSlider(
                    value: sliderValue,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        sliderValue = value;
                      });
                    },
                  ),

                  SizedBox(height: 30),
                  // ---------------- Task - 03 ----------------
                  Text(
                    "Phase - 03: Mood & Color Mixer",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  GestureDetector(
                    onLongPress: () {
                      print("HEX Code: $hexCode");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Copied: $hexCode")),
                      );
                    },
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        boxSize += details.delta.dx;
                        boxSize = boxSize.clamp(50, 300);
                      });
                    },
                    child: Container(
                      height: boxSize,
                      width: boxSize,
                      color: mixedColor,
                      alignment: Alignment.center,
                      child: Text(
                        hexCode,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // RGB Sliders
                  buildColorSlider("Red", red, Colors.red, (value) {
                    setState(() => red = value);
                  }),

                  buildColorSlider("Green", green, Colors.green, (value) {
                    setState(() => green = value);
                  }),

                  buildColorSlider("Blue", blue, Colors.blue, (value) {
                    setState(() => blue = value);
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildColorSlider(
  String label,
  double value,
  Color color,
  Function(double) onChanged,
) {
  return Column(
    children: [
      Text("$label: ${value.toInt()}"),
      Slider(
        value: value,
        min: 0,
        max: 255,
        activeColor: color,
        onChanged: onChanged,
      ),
    ],
  );
}