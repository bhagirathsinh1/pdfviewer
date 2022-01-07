import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdfviewer/SQLService/recent_pdf_model.dart';
import 'package:pdfviewer/MainPages/home_page.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';

import 'package:pdfviewer/widget/bottomsheet_recent.dart';
import 'package:pdfviewer/widget/page_view.dart';
import 'package:pdfviewer/widget/recent_clear.dart';
import 'package:provider/provider.dart';

// List<String> reversed_recent_list = [];
// var arriveDataRecent;

class Recentpage extends StatefulWidget {
  const Recentpage({Key? key}) : super(key: key);

  @override
  _RecentpageState createState() => _RecentpageState();
}

class _RecentpageState extends State<Recentpage> {
  @override
  void initState() {
    Provider.of<PdfFileService>(context, listen: false).starPDF();
    super.initState();
    // reversed_recent_list = recent_list.reversed.toList();
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
            ///search button

            ///more

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
        body: Consumer<PdfFileService>(builder: (context, counter, child) {
          return FutureBuilder(
            future: counter.getallPDFRecent(),
            builder: (BuildContext context,
                AsyncSnapshot<List<RecentListPdfModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  print("------------------response positive-------------");

                  if (snapshot.data!.isEmpty) {
                    return Center(child: Text("Data is empty !"));
                  } else {
                    return ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        File filesize = File(
                          snapshot.data![index].recentpdf.toString(),
                        );
                        var finalFileSize = filesize.lengthSync();
                        var sizeInKb =
                            (finalFileSize / (1024)).toStringAsFixed(2);

                        File datefile = new File(
                          snapshot.data![index].recentpdf.toString(),
                        );

                        var lastModDate1 = datefile.lastModifiedSync();
                        var formattedDate =
                            DateFormat('EEE, M/d/y').format(lastModDate1);
                        print("dataaay is $snapshot.data![index].recentpdf");
                        return Card(
                          child: ListTile(
                            title: Text(snapshot.data![index].recentpdf!
                                .split('/')
                                .last
                                .toString()),
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
                              Icon(
                                Icons.star,
                                color: Homepage.starPDF.toString().contains(
                                        snapshot.data![index].recentpdf
                                            .toString())
                                    ? Colors.blue
                                    : Colors.white,
                              ),
                              IconButton(
                                onPressed: () async {
                                  var fileName = snapshot.data![index].recentpdf
                                      .toString();

                                  var isFavourite =
                                      await showModalBottomSheet<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return BotomsheetRecentPage(
                                          fileName: fileName,
                                          index: index,
                                          snapshot: snapshot);
                                    },
                                  );
                                  // snapshot.data![index].isFavourite =
                                  //     isFavoutite;
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
                                      pathPDF: snapshot.data![index].recentpdf
                                          .toString(),
                                    );
                                    //open viewPDF page on click
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
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
          );
        }));
  }
}
