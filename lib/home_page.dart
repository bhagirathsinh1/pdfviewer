import 'package:flutter/material.dart';
import 'package:pdfviewer/search_page.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/browsmorefile.dart';
import 'package:pdfviewer/widget/homepopupmenu.dart';
import 'package:pdfviewer/widget/listallpdf.dart';
import 'package:pdfviewer/widget/reloadpdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);
  static List starPDF = [];
  static var favorite_index;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // TextEditingController textGotoValue = TextEditingController();

  String? formattedDate;
  var finalFileSize;
  bool isMyFiles = false;

  @override
  void initState() {
    Provider.of<PdfFileService>(context, listen: false)
        .starPDF(); // setState(() {});
    super.initState();
  }

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
                      " ${Provider.of<PdfFileService>(context, listen: false).files.length} pdf found !",
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
            body: Provider.of<PdfFileService>(context, listen: false)
                    .files
                    .isEmpty
                ? ReloadPdf()
                : ListAllPdf()),
      );
    });
  }
}
