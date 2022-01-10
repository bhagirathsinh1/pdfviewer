import 'package:flutter/material.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:provider/provider.dart';

class ReloadPdf extends StatefulWidget {
  ReloadPdf({Key? key}) : super(key: key);

  @override
  _ReloadPdfState createState() => _ReloadPdfState();
}

class _ReloadPdfState extends State<ReloadPdf> {
  bool isShowFiles = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfFileService>(builder: (context, counter, child) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                counter.getFiles();
                isShowFiles = true;

                print("......get my files bool 1....");
              },
              child: isShowFiles ? Text("Get files") : Text("Reload Pdf"),
            ),
          ],
        ),
      );
    });
  }
}
