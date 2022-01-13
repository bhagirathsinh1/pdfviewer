import 'package:flutter/material.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:provider/provider.dart';

class ReloadPdf extends StatefulWidget {
  ReloadPdf({Key? key}) : super(key: key);

  @override
  _ReloadPdfState createState() => _ReloadPdfState();
}

class _ReloadPdfState extends State<ReloadPdf> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PdfFileService>(builder: (context, counter, child) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                counter.getStorageFilleMethod();
              },
              child: Text("Reload Pdf"),
            ),
          ],
        ),
      );
    });
  }
}
