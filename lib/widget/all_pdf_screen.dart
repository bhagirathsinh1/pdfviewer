import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_serrvice.dart';
import 'package:pdfviewer/SQLService/recent_pdf_service.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/dialogue/delete_dialouge.dart';
import 'package:pdfviewer/MainPages/home_page.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/CommonWidget/delete_file_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/share_file_widget.dart';
import 'package:pdfviewer/widget/page_view.dart';
import 'package:pdfviewer/widget/CommonWidget/rename_files_widget.dart';
import 'package:provider/provider.dart';

class ListAllPdf extends StatefulWidget {
  ListAllPdf({Key? key}) : super(key: key);

  @override
  _ListAllPdfState createState() => _ListAllPdfState();
}

class _ListAllPdfState extends State<ListAllPdf> {
  var finalFileSize;
  String? formattedDate;

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfFileService>(
      builder: (context, pdfservice, child) {
        return ListView.builder(
          // reverse: isReverse Sized,
          //if file/folder list is grabbed, then show here
          itemCount: pdfservice.files.length,
          itemBuilder: (BuildContext ctxt, index) {
            File filesize = File(
              pdfservice.files[index].path.toString(),
            );
            finalFileSize = filesize.lengthSync();
            var sizeInKb = (finalFileSize / (1024)).toStringAsFixed(2);

            File datefile = new File(
              pdfservice.files[index].path.toString(),
            );

            var lastModDate1 = datefile.lastModifiedSync();
            formattedDate = DateFormat('EEE, M/d/y').format(lastModDate1);
            return Card(
              child: ListTile(
                title: Text(pdfservice.files[index].path.split('/').last),
                subtitle: sizeInKb.length < 7
                    ? Text("${formattedDate.toString()}\n${sizeInKb} Kb")
                    : Text(
                        "${formattedDate.toString()}\n${(finalFileSize / (1024.00 * 1024)).toStringAsFixed(2)} Mb"),
                leading: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                ),
                trailing: Wrap(
                  children: [
                    Icon(
                      Icons.star,
                      color: Homepage.starPDF
                              .toString()
                              .contains(pdfservice.files[index].path.toString())
                          ? Colors.blue
                          : Colors.white,
                    ),
                    IconButton(
                      onPressed: () {
                        var fileName = pdfservice.files[index].path;
                        Homepage.favorite_index = index;
                        print(fileName);
                        // recent_index = index;
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            var paths = Provider.of<PdfFileService>(context,
                                    listen: false)
                                .files[Homepage.favorite_index]
                                .path;
                            return Container(
                              color: Colors.white,
                              height: 350,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.yellow[100],
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 5,
                                        )),
                                    child: ListTile(
                                      title: Text(
                                          Provider.of<PdfFileService>(context,
                                                  listen: false)
                                              .files[Homepage.favorite_index]
                                              .path
                                              .split('/')
                                              .last,
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          )),
                                      leading: Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.red,
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                  ShareFiles(
                                      fileName: fileName,
                                      index: index,
                                      snapshot: null,
                                      paths: paths),
                                  ListTile(
                                    title: Homepage.starPDF.toString().contains(
                                            Provider.of<PdfFileService>(context,
                                                    listen: false)
                                                .files[Homepage.favorite_index]
                                                .path
                                                .toString())
                                        ? Text(
                                            "Remove from favorite",
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                            ),
                                          )
                                        : Text(
                                            "Add to favorite",
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                            ),
                                          ),
                                    leading: Homepage.starPDF
                                            .toString()
                                            .contains(Provider.of<
                                                        PdfFileService>(context,
                                                    listen: false)
                                                .files[Homepage.favorite_index]
                                                .path
                                                .toString())
                                        ? Icon(
                                            Icons.star_border,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          )
                                        : Icon(
                                            Icons.star,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                    onTap: () async {
                                      Homepage.starPDF.toString().contains(
                                              Provider.of<PdfFileService>(
                                                      context,
                                                      listen: false)
                                                  .files[
                                                      Homepage.favorite_index]
                                                  .path
                                                  .toString())
                                          ? removeFromFavorite()
                                          : addFavorite();
                                    },
                                  ),
                                  RenameFileWidget(
                                    index: index,
                                    fileName: fileName,
                                  ),
                                  DeleteFileWidget(
                                    index: index,
                                    fileName: fileName,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  // recent_index = index;

                  Map<String, Object> data = {
                    'recentpdf': (pdfservice.files[index].path),
                  };

                  if (!data.isEmpty) {
                    try {
                      var value = await RecentSQLPDFService()
                          .insertRecentPDF(data, SqlModel.tableRecent);
                    } catch (e) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.toString(),
                          ),
                        ),
                      );
                    }
                    print("pdfname is--------------> $data");
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ViewPDF(
                          pathPDF: pdfservice.files[index].path,
                        );
                        //open ViewPDFHomeScreen page on click
                      },
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  removeFromFavorite() async {
    Provider.of<PdfFileService>(context, listen: false)
        .removeFromFavoriteCalled(
            Provider.of<PdfFileService>(context, listen: false)
                .files[Homepage.favorite_index]
                .path
                .toString(),
            SqlModel.tableFavorite);

    Navigator.pop(context);
  }

  addFavorite() async {
    Map<String, Object> data = {
      'pdf': (Provider.of<PdfFileService>(context, listen: false)
          .files[Homepage.favorite_index]
          .path),
    };
    if (!data.isEmpty) {
      try {
        await SQLPDFService().insertPDF(data, SqlModel.tableFavorite);
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
      // print("pdfname is--------------> $data");
    }
    Navigator.pop(context);
    // initState();
  }
}
