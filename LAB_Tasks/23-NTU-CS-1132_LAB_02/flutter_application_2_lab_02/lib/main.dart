import 'package:flutter/material.dart';

void main() {
  runApp(Application2());
}

class Application2 extends StatelessWidget {
  const Application2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Flutter LAB - 02')),
          backgroundColor: Colors.green,
        ),

        // ------------Task - 01 -------------------------

        // backgroundColor: Colors.blueGrey,
        // body: SafeArea(
        //   child: Center(
        //     child: Container(
        //       width: 250,
        //       height: 250,
        //       margin: EdgeInsets.all(25.0),
        //       padding: EdgeInsets.symmetric(vertical: 15.0),
        //       color: Colors.white,
        //       child: Center(child: Text("Akasha Fatima",
        //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //       )),
        //     ),
        //   ),
        // ),

        // ---------- Task - 02 -----------------------

        // body: Container(
        //   width: double.infinity,
        //   color: Colors.white,
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     crossAxisAlignment: CrossAxisAlignment.end,
        //     children: [
        //       Icon(Icons.favorite, size: 50,),

        //       SizedBox(height: 60),

        //       Icon(Icons.thumb_up, size: 50,),
        //       Icon(Icons.share, size: 50,),
        //     ],
        //   ),
        // ),

        // ----------------- Task - 03 -----------------
        // body: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.stretch,
        //   children: [
        //     Center(
        //       child: Text(
        //         "Column-Wise Alignment",
        //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //       ),
        //     ),

        //     Icon(Icons.volume_up, size: 50),
        //     Icon(Icons.volume_down, size: 50),
        //     Icon(Icons.wifi, size: 50),
        //   ],
        // ),

      // --------------- Task - 04 ---------------------
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: Colors.blue,
            height: 100,
            width: double.infinity,
          ),

          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
                height: 80,
                color: Colors.red,
              ),
              Container(
                width: 80,
                height: 80,
                color: Colors.green,
              )
            ],
          )
        ],
      ),


      ),
    );
  }
}
