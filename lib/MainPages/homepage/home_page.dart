import 'package:flutter/material.dart';
import 'package:pdfviewer/MainPages/homepage/sorting_doalog.dart';
import 'package:pdfviewer/MainPages/searchpage/search_icon.dart';
import 'package:pdfviewer/MainPages/searchpage/search_page.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/MainPages/homepage/browsmorefile_dialog.dart';
import 'package:pdfviewer/MainPages/homepage/homepage_body.dart';
import 'package:pdfviewer/MainPages/homepage/reloadpdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfFileService>(builder: (context, counter, child) {
      return Scaffold(
          appBar: AppBar(
            title: Permission.storage.request().isGranted == true
                ? Text(
                    "PDF Reader",
                    style: TextStyle(color: Colors.black),
                  )
                : Text(
                    " ${counter.files.length} pdf found !",
                    style: TextStyle(color: Colors.black),
                  ),
            backgroundColor: Colors.white,
            actions: <Widget>[
              ///search button
              SearchIcon(),
              Shorting(),
              BrowsMoreFilePopUp(),
            ],
          ),
          body: counter.files.isEmpty ? ReloadPdf() : HomepageBody());
    });
  }
}
