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
  final String img;
  ViewArticle(this.img);
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
            Text("""A NoSQL (originally referring to "non-SQL" or "non-relational")[1] database provides a mechanism for storage and retrieval of data that is modeled in means other than the tabular relations used in relational databases. Such databases have existed since the late 1960s, but the name "NoSQL" was only coined in the early 21st century,[2] triggered by the needs of Web 2.0 companies.[3][4] NoSQL databases are increasingly used in big data and real-time web applications.[5] NoSQL systems are also sometimes called "Not only SQL" to emphasize that they may support SQL-like query languages or sit alongside SQL databases in polyglot-persistent architectures.[6][7]

                Motivations for this approach include: simplicity of design, simpler "horizontal" scaling to clusters of machines (which is a problem for relational databases),[2] finer control over availability and limiting the object-relational impedance mismatch.[8] The data structures used by NoSQL databases (e.g. key–value pair, wide column, graph, or document) are different from those used by default in relational databases, making some operations faster in NoSQL. The particular suitability of a given NoSQL database depends on the problem it must solve. Sometimes the data structures used by NoSQL databases are also viewed as "more flexible" than relational database tables.[9]

          Many NoSQL stores compromise consistency (in the sense of the CAP theorem) in favor of availability, partition tolerance, and speed. Barriers to the greater adoption of NoSQL stores include the use of low-level query languages (instead of SQL, for instance), lack of ability to perform ad-hoc joins across tables, lack of standardized interfaces, and huge previous investments in existing relational databases.[10] Most NoSQL stores lack true ACID transactions, although a few databases have made them central to their designs. """,
            style: TextStyle(fontSize: 20),)
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
                            builder: (_) => ViewArticle(docSnap['img'])));
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
