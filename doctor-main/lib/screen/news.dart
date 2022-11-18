import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toseeadoctor/screen/web_view_in_app.dart';

class FirestoreExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Example App',
      theme: ThemeData.light(),
      home: const Scaffold(
        body: Center(child: NewsCardList()),
      ),
    );
  }
}

/// Holds all example app films
class NewsCardList extends StatefulWidget {
  const NewsCardList({Key? key}) : super(key: key);

  @override
  _NewsCardListState createState() => _NewsCardListState();
}

class _NewsCardListState extends State<NewsCardList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff7CDDC4),
        centerTitle: true,
        title: Text(
          'บทความเเละข่าวสาร',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[],
      ),
      body:
          //TODO โหลดข้อมูลจาก Firestore เเบบ Stream เมื่อมีการเปลี่ยนแปลงข้อมูลใดๆ ใน Firestore ข้อมูลจะเปลี่ยนตามทันที
          StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("news")
            .where('active', isEqualTo: true)
            .orderBy('create_time', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            // TODO Loading...
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          // TODO แสดงรายการเเบบ list เป็นเเถว
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot data = snapshot.data!.docs[index];
                return Center(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        // TODO เรียก web view
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebViewInApp(
                                      initialUrl: data['link'],
                                    )));
                      },
                      child: Row(
                        children: [
                          // TODO เเสดง image ข่าวสาร
                          Image.network(data['imageURL'],
                              height: 120, width: 150, fit: BoxFit.cover),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 13.0),
                            child: Column(
                              children: [
                                // TODO เเสดง หัวข้อข่าวสาร
                                Text(
                                  data['title'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ],
                            ),
                          )),
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
