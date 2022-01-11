import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/avd.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/botttomsheet_fav.dart';
import 'package:pdfviewer/widget/favorite_clear_widget.dart';

import 'package:pdfviewer/widget/page_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Favouritepage extends StatefulWidget {
  const Favouritepage({Key? key}) : super(key: key);

  @override
  _FavouritepageState createState() => _FavouritepageState();
}

class _FavouritepageState extends State<Favouritepage> {
  @override
  // void initState() {
  //   super.initState();
  // }

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
                    File filesize =
                        File(pdfservice.favoritePdfList[index].pdf.toString());
                    var finalFileSize = filesize.lengthSync();
                    var sizeInKb = (finalFileSize / (1024)).toStringAsFixed(2);

                    File datefile = new File(
                        pdfservice.favoritePdfList[index].pdf.toString());

                    var lastModDate1 = datefile.lastModifiedSync();
                    var formattedDate =
                        DateFormat('EEE, M/d/y').format(lastModDate1);
                    return Card(
                      child: ListTile(
                        title: Text(pdfservice.favoritePdfList[index].pdf!
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
                            var fileName = pdfservice.favoritePdfList[index].pdf
                                .toString();

                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return BottomsheetFavoritePage(
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
                        onTap: () {
                          Future.delayed(
                            Duration.zero,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ViewPDF(
                                      pathPDF: pdfservice
                                          .favoritePdfList[index].pdf
                                          .toString(),
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
