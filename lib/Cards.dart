import 'dart:developer';
import 'dart:io';

import 'package:cr_file_saver/file_saver.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:thebookstoreapp/Favorate.dart';
import 'package:thebookstoreapp/FileManager.dart';
import 'package:thebookstoreapp/PDFviwer.dart';
import 'dBThings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomCard extends StatefulWidget {
  final String bookName;
  final String bookAuther;
  final String bookDescription;
  final String URLimage;
  final String URLpdf;

  CustomCard(this.bookName, this.bookAuther, this.bookDescription,
      this.URLimage, this.URLpdf);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  late SharedPreferences prefs;
  bool isButtonDisabled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    test();
  }

  void test() async {
    isButtonDisabled = await FileManager.doesFileExist(widget.bookName);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () async {
      if (await FileManager.doesFileExist(widget.bookName) == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Download The PDF file First'),
            duration: Duration(seconds: 2), // Set the duration
          ),
        );
      }

      else if (await FileManager.doesFileExist(widget.bookName) == true){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PDFviewer(widget.bookName)));
      }
    },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Color(0xFFE5E5E5),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.URLimage,
                    width: 150, // Adjust the width as needed
                    height: 250, // Adjust the height as needed
                    fit: BoxFit
                        .fitWidth, // Ensure the width fits within the specified width
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Book Name: ${widget.bookName}",
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                        Text(
                          "Author: ${widget.bookAuther}",
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: FlutterFlowTheme.of(context).accent4,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Book Description: ${widget.bookDescription}",
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            ),
            StyledDivider(
              thickness: 1,
              color: FlutterFlowTheme.of(context).accent4,
              lineStyle: DividerLineStyle.dashdotted,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FFButtonWidget(
                  onPressed: () {
                    SQLHelper.createItem(
                            widget.bookName,
                            widget.bookAuther,
                            widget.bookDescription,
                            widget.URLimage,
                            "bookPDFLink")
                        .then((value) {
                      if (value > 0) {
                        print('Item created successfully with ID: $value');
                      } else {
                        print('Failed to create item');
                      }
                    });
                  },
                  text: 'Favorite',
                  icon: const Icon(Icons.favorite),
                  options: FFButtonOptions(
                    height: 40,
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
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
                FFButtonWidget(
                  onPressed:  () async {
                    if (await FileManager.doesFileExist(widget.bookName) == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('PDF file Already exists'),
                          duration: Duration(seconds: 2), // Set the duration
                        ),
                      );
                    }

                    else if (await FileManager.doesFileExist(widget.bookName) == false){
                      await FileManager.downLoadFile(
                          widget.bookName, widget.URLpdf);
                    }
                  },
                  text: 'Download PDF',
                  icon: const Icon(Icons.picture_as_pdf),
                  options: FFButtonOptions(
                    height: 40,
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: isButtonDisabled
                        ? CupertinoColors.inactiveGray
                        : FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
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
          ],
        ),
      ),
    );
  }
}

class CustomCard2 extends StatefulWidget {
  final String bookName;
  final String bookAuther;
  final String bookDescription;
  final String URLimage;
  final String URLpdf;
  final Function(String) deleteTheBookFromThePage;

  CustomCard2(this.bookName, this.bookAuther, this.bookDescription,
      this.URLimage, this.deleteTheBookFromThePage, this.URLpdf);

  @override
  State<CustomCard2> createState() => _CustomCard2State();
}

class _CustomCard2State extends State<CustomCard2> {
  bool isButtonDisabled = false;

  void test() async {
    isButtonDisabled = await FileManager.doesFileExist(widget.bookName);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await FileManager.doesFileExist(widget.bookName) == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Download The PDF file First'),
              duration: Duration(seconds: 2), // Set the duration
            ),
          );
        }

        else if (await FileManager.doesFileExist(widget.bookName) == true){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PDFviewer(widget.bookName)));
        }
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Color(0xFFE5E5E5),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.URLimage,
                    width: 150, // Adjust the width as needed
                    height: 250, // Adjust the height as needed
                    fit: BoxFit
                        .fitWidth, // Ensure the width fits within the specified width
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Book Name: ${widget.bookName}",
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                        Text(
                          "Author: ${widget.bookAuther}",
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: FlutterFlowTheme.of(context).accent4,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Book Description: ${widget.bookDescription}",
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            ),
            StyledDivider(
              thickness: 1,
              color: FlutterFlowTheme.of(context).accent4,
              lineStyle: DividerLineStyle.dashdotted,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FFButtonWidget(
                  onPressed: () async {
                    int result = await SQLHelper.deleteItem(widget.bookName);
                    if (result != -1) {
                      widget.deleteTheBookFromThePage(widget.bookName);
                      print('Item deleted successfully');
                    } else {
                      print('Failed to delete item');
                    }
                  },
                  text: 'Unfavorite',
                  icon: const Icon(Icons.delete),
                  options: FFButtonOptions(
                    height: 40,
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
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
                FFButtonWidget(
                  onPressed: isButtonDisabled
                      ? null
                      : () async {
                          await FileManager.downLoadFile(
                              widget.bookName, widget.URLpdf);
                          setState(() {});
                        },
                  text: 'Download PDF',
                  icon: const Icon(Icons.picture_as_pdf),
                  options: FFButtonOptions(
                    height: 40,
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
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
          ],
        ),
      ),
    );
  }
}


class CustomCardNotes extends StatefulWidget {
  final String note;
  final String pageNumber;
  final String noteId;

  final Function(String) deleteNote;

  CustomCardNotes(this.note, this.pageNumber, this.deleteNote, this.noteId);

  @override
  State<CustomCardNotes> createState() => _CustomCardNotesState();
}

class _CustomCardNotesState extends State<CustomCardNotes> {
  bool isButtonDisabled = false;



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print("object");
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Color(0xFFE5E5E5),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Page Number: ${widget.pageNumber}",
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                FFButtonWidget(
                  onPressed: () async {
                    print("${widget.noteId} this is from the Card Class");
                    await widget.deleteNote(widget.noteId);
                  },
                  text: '',
                  icon: const Icon(Icons.delete),
                  options: FFButtonOptions(
                    height: 40,
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: FlutterFlowTheme.of(context).error,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
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
                ), ],
            ),
            Divider(
              thickness: 1,
              color: FlutterFlowTheme.of(context).accent4,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Note: ${widget.note}",
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            ),


          ],
        ),
      ),
    );
  }
}