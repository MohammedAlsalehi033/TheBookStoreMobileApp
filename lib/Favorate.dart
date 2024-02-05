import 'package:flutter/material.dart';
import 'package:thebookstoreapp/Cards.dart';
import 'package:thebookstoreapp/dBThings.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';


class FavorateScreen extends StatefulWidget {
  const FavorateScreen({super.key});

  @override
  State<FavorateScreen> createState() => _FavorateScreenState();
}

class _FavorateScreenState extends State<FavorateScreen> {
  List<Map<String, dynamic>> favorateBooks = [];

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
              'Your favourite books',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: SQLHelper.getBooks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Assign the snapshot.data to the local variable
              favorateBooks = snapshot.data ?? [];

              deleteBook(String bookName) {

                  setState(() {     favorateBooks = List.from(favorateBooks);
                favorateBooks.removeWhere((book) => book['bookName'] == bookName);});
              }

              return ListView.builder(
                itemCount: favorateBooks.length,
                itemBuilder: (context, index) {
                  return CustomCard2(
                    favorateBooks[index]['bookName'],
                    favorateBooks[index]['bookAuthor'],
                    favorateBooks[index]['bookDescription'],
                    favorateBooks[index]['bookImage'],

                    deleteBook,
                    favorateBooks[index]['bookPDFLink'],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}