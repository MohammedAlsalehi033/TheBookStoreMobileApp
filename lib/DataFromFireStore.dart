
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thebookstoreapp/Favorate.dart';
import 'firebase_options.dart';
import 'Cards.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'PDFviwer.dart';

class DataFromFireStore extends StatefulWidget {
  const DataFromFireStore({Key? key}) : super(key: key);

  @override
  State<DataFromFireStore> createState() => _DataFromFireStoreState();
}

class _DataFromFireStoreState extends State<DataFromFireStore> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Align(
            alignment: AlignmentDirectional(0, 0),
            child: Text(
              'Books For Today',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
          actions: [IconButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => FavorateScreen()));}, icon: Icon(color: Colors.white,Icons.star)),],
          centerTitle: true,
          elevation: 2,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("books").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
      
                List<DocumentSnapshot> documents = snapshot.data!.docs;
      
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
                    return CustomCard(data['bookname'], data['bookAuther'],data['bookDescription'],data['bookImageURL'],data['bookPDFlink']);
                  },
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
            }
              return Center(child: CircularProgressIndicator());
      
          },
        ),
      ),
    );
  }
}
