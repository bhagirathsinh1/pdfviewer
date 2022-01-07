import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';

import 'package:provider/provider.dart';

class DeleteFileDialouge extends StatefulWidget {
  final int index;
  final String fileName;
  DeleteFileDialouge({Key? key, required this.index, required this.fileName})
      : super(key: key);

  @override
  _DeleteFileDialougeState createState() => _DeleteFileDialougeState();
}

class _DeleteFileDialougeState extends State<DeleteFileDialouge> {
  @override
  void initState() {
    super.initState();
  }

  // set up the AlertDialog
  @override
  Widget build(BuildContext context) {
    // set up the buttons
    return AlertDialog(
      title: Text("Alert!"),
      content:
          Text("Would you like to delete ${widget.fileName.split('/').last}"),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("Continue"),
          onPressed: () {
            print("${widget.fileName.split('/').last}");

            deleteMethod();
          },
        )
      ],
    );
  }

  deleteMethod() {
    Provider.of<PdfFileService>(context, listen: false)
        .deleteFile(
      File(
        widget.fileName,
      ),
    )
        .whenComplete(() {
      Provider.of<PdfFileService>(context, listen: false)
          .removeFromFavoriteCalled(widget.fileName, SqlModel.tableFavorite);
      Provider.of<PdfFileService>(context, listen: false)
          .removeFromRecent(widget.fileName, SqlModel.tableRecent);
      Navigator.pop(context);
      showAlertDialog(context);
    });

    // );
  }

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Succesfuly deleted"),
          content: Text(widget.fileName.toString().split('/').last),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
    // Navigator.pop(context);
  }
}