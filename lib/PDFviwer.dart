import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:thebookstoreapp/dBThings.dart';
import 'Cards.dart';

class PDFviewer extends StatefulWidget {
  final String bookName;

  const PDFviewer(this.bookName);

  @override
  State<PDFviewer> createState() => _PDFviewerState();
}

class _PDFviewerState extends State<PDFviewer> {
  late PDFViewController controller;
  int pages = 0;
  int indexPage = 0;
  double jumpToPage = 1;


  // this is add so there will be 2 list one is from the sql and it is unchangeable and the other is the dynamic one that changes with the UI and the beginning this one is initiated with the sql data then it grows by itself
  List<Map<String, dynamic>> favorateBooks = [];

  // Add a TextEditingController for note input
  TextEditingController noteController = TextEditingController();

  // List to store old notes
  List<String> oldNotes = ["note 1", "note 2", "note 3", "note 4"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getNotes();
  }

  void getNotes() async {
    List<Map<String, dynamic>> favorateBooks =
        await SQLHelperForNotes.getNotes();
    this.favorateBooks = favorateBooks.toList();
  }

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
              widget.bookName,
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Outfit',
                    color: Colors.white,
                    fontSize: 22,
                  ),
            ),
          ),
          centerTitle: false,
          elevation: 2,
        ),
        body: DefaultTabController(
          length: 3,
          child: SlidingUpPanel(
            parallaxEnabled: true,
            panelSnapping: false,
            onPanelSlide: (position) {
              setState(() {});
            },
            body: Stack(children: [
              PDFView(
                onRender: (pages) => setState(() {
                  this.pages = pages!;
                }),
                onViewCreated: (controller) => setState(() {
                  this.controller = controller;
                }),
                onPageChanged: (indexPage, _) {
                  setState(() {
                    this.indexPage = indexPage!;
                  });
                },
                filePath: "/storage/emulated/0/Download/${widget.bookName}.pdf",
                pageSnap: false,
                pageFling: false,
              ),
              Positioned(
                  child: Container(
                decoration: BoxDecoration(
                    ),
                child: Container(color: FlutterFlowTheme.of(context).primary,
                  child: TabBar(
                    tabs: [
                      Tab(text: 'New Note'),
                      Tab(text: 'Old Notes'),
                      Tab(text: 'Navigate'),
                    ],
                    labelColor: Colors.white,
                    indicatorColor: Colors.white,
                    unselectedLabelColor: Colors.white,
                  ),
                ),
              ))
            ]),
            panel: TabBarView(
              children: [
                // Tab 1 Add note
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add New Note',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      // Add a TextFormField for note input
                      TextFormField(
                        controller: noteController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Write your new note here...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Add a button to save new note
                      FFButtonWidget(
                        onPressed: () {
                          String newNote = noteController.text;
                          String noteId = DateTime.now().millisecondsSinceEpoch.toString();
                          SQLHelperForNotes.createItem(
                              noteId,
                              widget.bookName,
                              newNote,
                              indexPage.toString());

                          Map<String, dynamic> newNote2 = {
                            'NoteID': noteId,
                            'book': widget.bookName,
                            'Note': newNote,
                            'PageNumber': indexPage.toString()
                          };
                          favorateBooks.add(newNote2);

                          noteController.text = "";
                          const snackBar = SnackBar(behavior: SnackBarBehavior.floating,duration: Duration(seconds: 1),
                            content: Text('Note Added'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        text: 'Add to notes',
                        icon: const Icon(Icons.note_alt_sharp),
                        options: FFButtonOptions(
                          height: 40,
                          padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                          iconPadding:
                              EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white,
                                  ),
                          elevation: 3,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),

                // --------------------------------------------------------------

                // Tab 2 View Old Notes
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'View Old Notes',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      FutureBuilder(
                        future: SQLHelperForNotes.getNotes(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List<Map<String, dynamic>> favorateBooks2 =
                                favorateBooks;
                            return Expanded(
                              child: ListView.builder(
                                itemCount: favorateBooks.length,
                                itemBuilder: (context, index) {
                                  return CustomCardNotes(
                                      favorateBooks[index]['Note'],
                                      favorateBooks[index]['PageNumber'],
                                      _deleteNote,
                                      favorateBooks[index]['NoteID']);
                                },
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),

                //---------------------------------------------------------------

                // Tab 3 Navigate
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Navigate among pages',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      // Slider to navigate between pages
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: indexPage.toDouble(),
                              min: 0,
                              max: pages > 0 ? (pages - 1).toDouble() : 0,
                              onChanged: (value) {
                                setState(() {
                                  indexPage = value.round();
                                });
                                controller.setPage(indexPage);
                              },
                            ),
                          ),
                        ],
                      ),
                      // Text field to target a specific page
                      Row(
                        children: [
                          Text('Go to Page:'),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 60,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  jumpToPage = double.tryParse(value) ?? 1;
                                });
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: () {
                              if (jumpToPage >= 1 && jumpToPage <= pages) {
                                setState(() {
                                  indexPage = (jumpToPage - 1).round();
                                });
                                controller.setPage(indexPage);
                              }
                            },
                          ),
                        ],
                      ),
                      // Display the page count
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Page: ${indexPage + 1} of $pages',
                              style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _deleteNote(String noteID) async {
    print(noteID);
    print("before: ${await SQLHelperForNotes.getNotes()}");

    // Wait for the delete operation to complete
    await SQLHelperForNotes.deleteItem(noteID);

    // Remove the item from the local list
    favorateBooks.removeWhere((e) => e['NoteID'] == noteID);

    // Update the state to trigger a rebuild of the UI
    setState(() {});

    print("after: ${await SQLHelperForNotes.getNotes()}");
  }

}
