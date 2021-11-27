import 'dart:io';
// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_serrvice.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_model.dart';
import 'package:pdfviewer/main.dart';
import 'package:pdfviewer/widget/page_view.dart';
import 'package:share/share.dart';

// var arriveData;

class Favouritepage extends StatefulWidget {
  const Favouritepage({Key? key}) : super(key: key);

  @override
  _FavouritepageState createState() => _FavouritepageState();
}

class _FavouritepageState extends State<Favouritepage> {
  @override
  void initState() {
    getallPDF();

    super.initState();
    // reversed_favorite_list = favorite_list.reversed.toList();
  }

  Future<List<FavouriteListPdfModel>> getallPDF() async {
    final dbClient = await SqlModel().db;
    List<Map<String, Object?>> futurePDFList =
        await dbClient.rawQuery("Select *from ${SqlModel.tableFavorite}");
    List<FavouriteListPdfModel> list = [];

    futurePDFList.forEach(
      (element) {
        list.add(FavouriteListPdfModel.fromJson(element));
      },
    );
    return list;
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
          ///search button

          ///more

          IconButton(
            onPressed: () {
              // favoriteBottomNavBar(context);
              favoriteBottomNavBar(context);
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getallPDF(),
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
                    var sizeInKb = (finalFileSize / (1024)).toStringAsFixed(2);

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

                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  color: Colors.white,
                                  height: 250,
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
                                            snapshot.data![index].pdf
                                                .toString()
                                                .split('/')
                                                .last,
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                            ),
                                          ),
                                          leading: Icon(
                                            Icons.picture_as_pdf,
                                            color: Colors.red,
                                          ),
                                          onTap: () {},
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          "Share",
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.share,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        onTap: () {
                                          List<String> paths = [
                                            snapshot.data![index].pdf.toString()
                                          ];
                                          Share.shareFiles(paths);
                                        },
                                      ),
                                      ListTile(
                                        title: Text(
                                          "Remove from favorite",
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.star,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(builder: (context) => pdfscreen()),
                                          // );
                                          await SQLPDFService()
                                              .removeFromFavorite(
                                                  snapshot.data![index].pdf
                                                      .toString(),
                                                  SqlModel.tableFavorite)
                                              .whenComplete(() {
                                            setState(() {});
                                          });
                                        },
                                      ),
                                      ListTile(
                                        title: Text(
                                          "Delete",
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.delete,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        onTap: () {
                                          deleteDialougeFavoriteScreen(
                                              context, snapshot, index);
                                        },
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
                        onTap: () {
                          Future.delayed(Duration.zero, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ViewPDF(
                                    pathPDF:
                                        snapshot.data![index].pdf.toString(),
                                  );
                                  //open viewPDF page on click
                                },
                              ),
                            );
                          });
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
      ),
    );
  }

  Future<void> favoriteBottomNavBar(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 70,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  "Clear Favorites",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.delete,
                  color: Colors.black.withOpacity(0.5),
                ),
                onTap: () async {
                  Navigator.pop(context);

                  await SQLPDFService()
                      .clearData(SqlModel.tableFavorite)
                      .whenComplete(() {
                    setState(() {});
                  });
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Favorite cleared !!"),
                  ));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  deleteDialougeFavoriteScreen(BuildContext context, snapshot, index) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        Future.delayed(
          const Duration(milliseconds: 500),
          () async {
            Navigator.pop(context);

            deleteMethodFavoriteScreen(context, snapshot, index);
          },
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert!"),
      content: Text(
          "Would you like to delete ${snapshot.data![index].pdf.toString().split('/').last}"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  deleteMethodFavoriteScreen(context, snapshot, index) async {
    await SQLPDFService().removeFromFavorite(
        snapshot.data![index].pdf.toString(), SqlModel.tableFavorite);
    deleteFileFavorite(
      File(
        snapshot.data![index].pdf.toString(),
      ),
    ).whenComplete(() {
      getFiles();
      getallPDF();
      showAlertDialogFavorite(context, snapshot, index);

      setState(() {});
    });
  }

  Future<void> deleteFileFavorite(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  showAlertDialogFavorite(BuildContext context, snapshot, index) {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Succesfuly deleted"),
      content: Text(snapshot.data![index].pdf.toString().split('/').last),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            setState(() {});
            ;
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
