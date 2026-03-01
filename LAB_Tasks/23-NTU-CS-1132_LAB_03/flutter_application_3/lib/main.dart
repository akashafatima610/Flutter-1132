import 'package:flutter/material.dart';

void main() {
  runApp(Application3());
}

class Application3 extends StatelessWidget {
  const Application3({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Flutter LAB - 03")),
          backgroundColor: Colors.green,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),

          actions: [
            // ---------------- Task - 03 ----------------
            Container(
              margin: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/profile.png'),
              ),
            ),
          ],
        ),

        body: SingleChildScrollView(
          child: Center(
            child: Column(
              // ---------------- Task - 01 ----------------
              mainAxisAlignment: MainAxisAlignment.center,
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
                      Icon(Icons.phone, size: 40, color: Colors.purple),
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

                // ------------------- Task - 02 ----------------
                const Divider(color: Colors.black, thickness: 3),

                const SizedBox(height: 30),

                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 50.0,
                    horizontal: 10.0,
                  ),
                  padding: EdgeInsets.all(20.0),
                  color: Colors.blueAccent,
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    padding: EdgeInsets.all(20.0),
                    color: Colors.redAccent,
                    child: const Text(
                      "This Container shows:\n\nPadding → inner space\nMargin → outer space",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // ------------------- Task - 03 ----------------
                const Divider(color: Colors.black, thickness: 3),

                const SizedBox(height: 30),

                const Text(
                  "This is the profile picture of the user.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAVKu9ltsW2BFG3T68866tsR2nCeKF-hQTgQ&s',
                  ),
                ),

                SizedBox(height: 30),

                // ------------------- Task - 04 ----------------
                const Divider(color: Colors.black, thickness: 3),

                const SizedBox(height: 30),

                // first version 

                Card(
                  elevation: 6,
                  color: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage( 'assets/profile.png'),
                    ),
                    title: Text("Akasha Fatima", 
                      style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text("Reg. No: 23-NTU-CS-FL-1132"),
                  ),
                ),

                SizedBox(height: 30),

                // second version
                Card(
                  elevation: 8,
                  color: Colors.limeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.account_circle,
                        size: 40, color: Colors.purple),
                    title: Text("Nimra Shahzadi",
                      style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text("Reg. No: 23-GCUF-CS-FL-1132"),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.deepPurpleAccent,),
                  ),
                ),

                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
