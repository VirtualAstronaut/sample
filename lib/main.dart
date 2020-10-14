import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//test 2
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade800,
        textTheme: TextTheme(
            headline6: TextStyle(color: Colors.white, fontSize: 25),
            bodyText1: TextStyle(color: Colors.grey.shade300, fontSize: 18))),
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class ViewArticle extends StatelessWidget {
  final String img,body;

  ViewArticle(this.img,this.body);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
          floating: true
            ,pinned: true,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(img,fit: BoxFit.cover,),
            ),
          ),
          SliverToBoxAdapter(child: Container(child:
            RichText(textAlign: TextAlign.center,
              text: TextSpan(
              children:[
                TextSpan(text: body,style: TextStyle(fontSize: 20))
              ]
            ),)
          ),)
        ],
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Posts').snapshots(),
        builder: (_, snap) {
          if (snap.hasError) {
            return Text('error');
          }
          if (snap.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: snap.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot docSnap = snap.data.documents[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ViewArticle(docSnap['img'],docSnap['body'])));
                  },
                  child: Card(
                    elevation: 10,
                    color: Colors.grey.shade600,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                              width: 400,
                              height: 100,
                              child: Image.network(docSnap['img'])),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Text(
                              docSnap['title'],
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Text(
                              docSnap['brief'],
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
