import 'package:flutter/material.dart';
import 'package:pdfviewer/MainPages/search_page.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/browsmorefile_dialog.dart';
import 'package:pdfviewer/widget/homepopupmenu.dart';
import 'package:pdfviewer/widget/all_pdf_screen.dart';
import 'package:pdfviewer/widget/reloadpdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  // void initState() {
  //   super.initState();

  //   Provider.of<PdfFileService>(context, listen: false)
  //       .starPDFMethod(); // setState(() {});
  // }
  @override
  Widget build(BuildContext context) {
    return Consumer<PdfFileService>(builder: (context, counter, child) {
      return Center(
        child: Scaffold(
            appBar: Permission.storage.request().isGranted == true
                ? AppBar(
                    title: Text(
                      "PDF Reader",
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.white,
                    actions: <Widget>[
                      ///search button
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage()),
                          );
                        },
                        icon: Icon(
                          Icons.search,
                          size: 26.0,
                          color: Colors.black,
                        ),
                      ),
                      HomePopupMenu(),
                      BrowsMoreFilePopUp(),
                    ],
                  )
                : AppBar(
                    title: Text(
                      " ${counter.files.length} pdf found !",
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.white,
                    actions: <Widget>[
                      ///search button
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage()),
                          );
                        },
                        icon: Icon(
                          Icons.search,
                          size: 26.0,
                          color: Colors.black,
                        ),
                      ),
                      HomePopupMenu(),
                      BrowsMoreFilePopUp(),
                    ],
                  ),
            body: counter.files.isEmpty ? ReloadPdf() : ListAllPdf()),
      );
    });
  }
}
