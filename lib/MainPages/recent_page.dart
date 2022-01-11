import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/bottomsheet_recent.dart';

import 'package:pdfviewer/widget/page_view.dart';

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
                    File filesize = File(
                        pdfservice.recentPdfList[index].recentpdf.toString());
                    var finalFileSize = filesize.lengthSync();
                    var sizeInKb = (finalFileSize / (1024)).toStringAsFixed(2);

                    File datefile = new File(
                        pdfservice.recentPdfList[index].recentpdf.toString());

                    var lastModDate1 = datefile.lastModifiedSync();
                    var formattedDate =
                        DateFormat('EEE, M/d/y').format(lastModDate1);

                    return Card(
                      child: ListTile(
                        title: Text(pdfservice.recentPdfList[index].recentpdf!
                            .toString()
                            .split("/")
                            .last),
                        subtitle: sizeInKb.length < 7
                            ? Text(
                                "${formattedDate.toString()}\n${sizeInKb} Kb")
                            : Text(
                                "${formattedDate.toString()}\n${(finalFileSize / (1024.00 * 1024)).toStringAsFixed(2)} Mb"),
                        leading: Icon(
                          Icons.picture_as_pdf,
                          color: Colors.red,
                        ),
                        trailing: Wrap(children: [
                          Consumer<PdfFileService>(
                              builder: (context, counter, child) {
                            return Icon(
                              Icons.star,
                              color: Provider.of<PdfFileService>(context,
                                          listen: false)
                                      .starPDF
                                      .toString()
                                      .contains(pdfservice
                                          .recentPdfList[index].recentpdf
                                          .toString())
                                  ? Colors.blue
                                  : Colors.white,
                            );
                          }),
                          IconButton(
                            onPressed: () async {
                              var fileName = pdfservice
                                  .recentPdfList[index].recentpdf
                                  .toString();

                              await showModalBottomSheet<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return BotomsheetRecentPage(
                                    fileName: fileName,
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
                                return ViewPDF(
                                  pathPDF: pdfservice
                                      .recentPdfList[index].recentpdf
                                      .toString(),
                                );
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
