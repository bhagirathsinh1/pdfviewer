import 'package:flutter/material.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:provider/provider.dart';

class DeleteFileDialouge extends StatefulWidget {
  final String fileName;

  DeleteFileDialouge({Key? key, required this.fileName}) : super(key: key);

  @override
  _DeleteFileDialougeState createState() => _DeleteFileDialougeState();
}

class _DeleteFileDialougeState extends State<DeleteFileDialouge> {
  bool isLoading = false;

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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () {
            Provider.of<PdfFileService>(context, listen: false)
                .deleteMethod(widget.fileName);
            Future.delayed(Duration(milliseconds: 10), () async {
              
              Navigator.pop(context);
            });
          },
          child: Text(
            'Continue',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
