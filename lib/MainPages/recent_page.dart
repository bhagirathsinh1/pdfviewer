import 'package:flutter/material.dart';
import 'package:pdfviewer/SQLService/recent_pdf_model.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/name_of_recentpdf.dart';

import 'package:pdfviewer/widget/recent_clear.dart';
import 'package:provider/provider.dart';

class Recentpage extends StatefulWidget {
  const Recentpage({Key? key}) : super(key: key);

  @override
  _RecentpageState createState() => _RecentpageState();
}

class _RecentpageState extends State<Recentpage> {
  @override
  void initState() {
    Provider.of<PdfFileService>(context, listen: false).starPDFMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "PDF Reader",
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return RecentClear();
                  },
                );
              },
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<PdfFileService>(context, listen: false)
              .getallPDFRecent(),
          builder: (BuildContext context,
              AsyncSnapshot<List<RecentListPdfModel>> snapshot) {
            print("--------------------$snapshot---------------------");
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                print("------------------response positive-------------");

                if (snapshot.data!.isEmpty) {
                  return Center(child: Text("Data is empty !"));
                } else {
                  return NameOfRecentPdf(snapshot: snapshot);
                }
              }
              if (snapshot.hasError) {
                return Text(snapshot.hasError.toString());
              } else {
                return Text("Somehting went weong");
              }
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ));
  }
}
