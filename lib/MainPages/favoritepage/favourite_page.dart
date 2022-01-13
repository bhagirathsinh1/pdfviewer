import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/avd.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/MainPages/favoritepage/botttomsheet_favoritepage.dart';
import 'package:pdfviewer/MainPages/favoritepage/favoritelist_clear_widget.dart';

import 'package:pdfviewer/widget/CommonWidget/page_view.dart';
import 'package:provider/provider.dart';

class Favouritepage extends StatefulWidget {
  const Favouritepage({Key? key}) : super(key: key);

  @override
  _FavouritepageState createState() => _FavouritepageState();
}

class _FavouritepageState extends State<Favouritepage> {
  @override
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
                      return FavoriteClear();
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
          body: pdfservice.favoritePdfList.isEmpty
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
                      "No Favorite pdf found!!",
                      style: TextStyle(color: Colors.grey.shade600),
                    )
                  ],
                ))
              : ListView.builder(
                  // reverse: true,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: pdfservice.favoritePdfList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var filePath =
                        pdfservice.favoritePdfList[index].pdfpath.toString();
                    var fileDate =
                        pdfservice.favoritePdfList[index].date.toString();
                    var fileSize =
                        pdfservice.favoritePdfList[index].size.toString();
                    var fileTitle =
                        pdfservice.favoritePdfList[index].pdfname.toString();

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
                        trailing: IconButton(
                          onPressed: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return BottomsheetFavoritePage(
                                  fileName: filePath,
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
                        onTap: () {
                          Future.delayed(
                            Duration.zero,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    var pathPdf = pdfservice
                                        .favoritePdfList[index].pdfpath
                                        .toString();
                                    //
                                    return ViewPDF(
                                      pathPDF: pathPdf,
                                      fileDate: fileDate,
                                      fileTitle: fileTitle,
                                      fileSize: fileSize,
                                      filePath: filePath,
                                      index: index,
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ));
    });
  }
}
