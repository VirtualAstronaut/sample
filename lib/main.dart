import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // @override
  // void initState() {
  //   super.initState();
  //   Firebase.initializeApp();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Posts').snapshots(),
        builder: (_, snap) {
          if (snap.hasError) {
            return Text('error');
          }
          return ListView.builder(
              itemCount: snap.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot docSnap = snap.data.documents[index];
                return GestureDetector(
                  onTap: () {
                    //some shit to implemeent
                  },
                  child: Card(
                    elevation: 10,
                    child: Column(
                      children: [
                        Container(
                            width: 500,
                            height: 100,
                            child: Image.network(docSnap['img'])),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Text(
                            docSnap['title'],
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Text(
                            docSnap['brief'],
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
