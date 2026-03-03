import 'package:flutter/material.dart';

void main() {
  runApp(Application4());
}

// ---------------- Task - 01 (stateless widget)----------------
// class Application4 extends StatelessWidget {
//   const Application4({super.key});

// ----------------- Task - 06 (stateful widget)----------------
class Application4 extends StatefulWidget {
  const Application4({super.key});

  @override
  State<Application4> createState() => _Application4State();
}

class _Application4State extends State<Application4> {
  bool isfollowed = false;
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Flutter LAB - 04")),
          backgroundColor: Colors.green,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        body: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ----------------- Task - 02 ----------------
                Container(
                  margin: EdgeInsets.all(20),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                ),

                // ----------------- Task - 03 ----------------
                Text(
                  'Akasha Fatima',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Software Engineer Student',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),

                // ----------------- Task - 05 ----------------
                SizedBox(
                  height: 160,

                  // ----------------- Task - 04 ----------------
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(20),
                          color: Colors.lightBlueAccent,
                          child: Text(
                            'About Degree - Pursuing a Bachelor of Science in Software Engineering at NTU - FSD.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(15),
                          color: Colors.blueAccent,
                          child: Text(
                            'About Skills - Proficient in programming languages such as Java, Python, and Dart.'
                            'Experienced in software development methodologies and tools.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // ----------------- Task - 07 (stateful widget)----------------
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isfollowed = !isfollowed;
                    });
                  },
                  child: Text(isfollowed ? 'Unfollow' : 'Follow',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      score++;
                    });
                  },
                ),

                // ----------------- Task - 08 ----------------
                Card(
                  elevation: 6,
                  margin: EdgeInsets.all(20),
                  child: ListTile(
                    leading: Icon(Icons.star, color: Colors.orange, size: 30),
                    title: Text('Profile Score:', 
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    subtitle: Text('Total Likes: $score',
                    style: TextStyle(fontSize: 16, color: Colors.grey)),

                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
