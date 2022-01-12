import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/MainPages/recentpage/bottomsheet_recentpage.dart';

import 'package:pdfviewer/widget/CommonWidget/page_view.dart';

import 'package:pdfviewer/MainPages/recentpage/recentlist_clear_widget.dart';
import 'package:provider/provider.dart';

class Recentpage extends StatefulWidget {
  const Recentpage({Key? key}) : super(key: key);

  @override
  _RecentpageState createState() => _RecentpageState();
}

class _RecentpageState extends State<Recentpage> {
  @override
  void initState() {
    // Provider.of<PdfFileService>(context, listen: false).getFavoritePdfList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfFileService>(builder: (context, pdfservice, child) {
      return Scaffold(
          backgroundColor: Colors.white,
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
          body: pdfservice.recentPdfList.isEmpty
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 200,
                        width: 200,
                        decoration: new BoxDecoration(
                            image: new DecorationImage(
                          image: new AssetImage("assets/icon/empty_image.gif"),
                          fit: BoxFit.fill,
                        ))),
                    Text(
                      "No Recent pdf found!!",
                      style: TextStyle(color: Colors.grey.shade600),
                    )
                  ],
                ))
              : ListView.builder(
                  // reverse: true,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: pdfservice.recentPdfList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var filePath =
                        pdfservice.recentPdfList[index].pdfpath.toString();
                    var fileDate =
                        pdfservice.recentPdfList[index].date.toString();
                    var fileSize =
                        pdfservice.recentPdfList[index].size.toString();
                    var fileTitle =
                        pdfservice.recentPdfList[index].pdfname.toString();
                    var isfav = pdfservice.favoritePdfList
                        .where((element) => element.pdfpath == filePath);
                    return Card(
                      child: ListTile(
                        title: Text(fileTitle),
                        subtitle: fileSize.length < 7
                            ? Text("${fileDate}\n${fileSize} Kb")
                            : Text(
                                "${fileDate}\n${(double.parse(fileSize) / 1024).toStringAsFixed(2)} Mb"),
                        leading: Icon(
                          Icons.picture_as_pdf,
                          color: Colors.red,
                        ),
                        trailing:
                            Wrap(alignment: WrapAlignment.center, children: [
                          IconButton(
                            onPressed: () async {},
                            constraints: BoxConstraints(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            icon: Icon(
                              Icons.star,
                              color:
                                  !isfav.isEmpty ? Colors.blue : Colors.white,
                            ),
                          ),
                          IconButton(
                            constraints: BoxConstraints(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 10),
                            onPressed: () async {
                              await showModalBottomSheet<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return BotomsheetRecentPage(
                                    fileName: filePath.toString(),
                                    index: index,
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.redAccent,
                            ),
                          ),
                        ]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                // return ViewPDF(
                                //   pathPDF: filePath,
                                // );
                                return ViewPDF(
                                    pathPDF: filePath,
                                    fileDate: fileDate,
                                    fileTitle: fileTitle,
                                    fileSize: fileSize,
                                    filePath: filePath,
                                    index: index);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ));
    });
  }
}
