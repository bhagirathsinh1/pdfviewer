import 'dart:io';
// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_model.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_serrvice.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/botttomsheet_fav.dart';
import 'package:pdfviewer/widget/favorite_clear_widget.dart';
import 'package:pdfviewer/widget/page_view.dart';
import 'package:provider/provider.dart';

class Favouritepage extends StatefulWidget {
  const Favouritepage({Key? key}) : super(key: key);

  @override
  _FavouritepageState createState() => _FavouritepageState();
}

class _FavouritepageState extends State<Favouritepage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "PDF Reader",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              // favoriteBottomNavBar(context);
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
      body: Consumer<PdfFileService>(
        builder: (context, counter, child) {
          return FutureBuilder(
            future: counter.getFavoritePdf(),
            builder: (BuildContext context,
                AsyncSnapshot<List<FavouriteListPdfModel>> snapshot) {
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
                          snapshot.data![index].pdf.toString(),
                        );
                        var finalFileSize = filesize.lengthSync();
                        var sizeInKb =
                            (finalFileSize / (1024)).toStringAsFixed(2);

                        File datefile = new File(
                          snapshot.data![index].pdf.toString(),
                        );

                        var lastModDate1 = datefile.lastModifiedSync();
                        var formattedDate =
                            DateFormat('EEE, M/d/y').format(lastModDate1);
                        print("dataaay is $snapshot.data![index].pdf");
                        return Card(
                          child: ListTile(
                            title: Text(snapshot.data![index].pdf!
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
                            trailing: IconButton(
                              onPressed: () {
                                // newindex = index;
                                var fileName =
                                    snapshot.data![index].pdf.toString();

                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BottomsheetFavoritePage(
                                        fileName: fileName,
                                        index: index,
                                        snapshot: snapshot);
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
                                        return ViewPDF(
                                          pathPDF: snapshot.data![index].pdf
                                              .toString(),
                                        );
                                        //open viewPDF page on click
                                      },
                                    ),
                                  );
                                },
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
                  return Text("Somehting went wrong");
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
        },
      ),
    );
  }
}
