import 'dart:io';

import 'package:flutter/material.dart';

import 'package:pdfviewer/main.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:provider/provider.dart';

class RenameFileDialouge extends StatefulWidget {
  final int index;
  final String fileName;
  RenameFileDialouge({Key? key, required this.index, required this.fileName})
      : super(key: key);

  @override
  _RenameFileDialougeState createState() => _RenameFileDialougeState();
}

class _RenameFileDialougeState extends State<RenameFileDialouge> {
  final _formKeyRenameFile = GlobalKey<FormState>();
  TextEditingController renameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    renameController.text = widget.fileName.split('/').last.split('.pdf').first;
  }

  // set up the AlertDialog
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Alert!"),
      content: Container(
        height: 70,
        child: Form(
          key: _formKeyRenameFile,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: renameController,
                validator: (value) {
                  if (value != null && value != "") {
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
                // Only numbers can be entered
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    helperText: 'Enter new name here '),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text("CANCEL"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("OK"),
          onPressed: () {
            var newFileName = renameController.text;
            print(newFileName.split('.'));
            changeFileNameOnly(context, newFileName);
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  changeFileNameOnly(BuildContext context, String newFileName) {
    // print("------------->arrived new name----$newFileName--------");
    // var pathOfFile = Provider.of<PdfFileService>(context, listen: false)
    //     .files[widget.index]
    //     .pdfpath
    //     .toString();
    // var lastSeparator = pathOfFile.lastIndexOf(Platform.pathSeparator);
    // var newPath =
    //     pathOfFile.substring(0, lastSeparator + 1) + newFileName + ".pdf";

    // Future<File> temp = Provider.of<PdfFileService>(context, listen: false)
    //     .files[widget.index]
    //     .rename(newPath);
    // temp.then(
    //   (v) {
    //     print("-------------v.path data---------------- ${v.path}");

    //     setState(
    //       () {
    //         Provider.of<PdfFileService>(context, listen: false)
    //             .files[widget.index] = v;

    //         print(
    //           "-------------MyApp.files path data---------------- ${Provider.of<PdfFileService>(context, listen: false).files[widget.index]}",
    //         );
    //       },
    //     );
    //   },
    // ).whenComplete(
    //   () {
    //     // FileService.getMyApp.files();
    //   },
    // ).whenComplete(
    //   () {
    //     Navigator.pop(context);
    //     ScaffoldMessenger.of(context).clearSnackBars();
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text("Renamed to  ${newFileName}"),
    //       ),
    //     );
    //     // setState(() {});
    //   },
    // );
  }
}
