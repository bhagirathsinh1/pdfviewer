import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_model.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_serrvice.dart';
import 'package:pdfviewer/SQLService/recent_pdf_service.dart';
import 'package:pdfviewer/SQLService/recent_pdf_model.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/home_page.dart';

import 'package:pdfviewer/main.dart';
import 'package:pdfviewer/widget/page_view.dart';
import 'package:share/share.dart';

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
    getallPDF();
    super.initState();
    // reversed_recent_list = recent_list.reversed.toList();
  }

  getallPDF() async {
    starPDF.clear();
    final dbClient = await SqlModel().db;

    List<Map<String, Object?>> tempPDF =
        await dbClient.rawQuery("Select *from ${SqlModel.tableFavorite}");
    starPDF.addAll(tempPDF);
    // print("------------temp pdf list----->$tempPDF--------------");
    // print("------------star pdf list----->${starPDF[0]}--------------");
    setState(() {});
  }

  Future<List<RecentListPdfModel>> getallPDFRecent() async {
    final dbClient = await SqlModel().db;
    List<RecentListPdfModel> list = [];

    List<Map<String, Object?>> futurePDFList = await dbClient.rawQuery(
      "Select *from ${SqlModel.tableRecent}",
    );

    futurePDFList.forEach(
      (element) {
        list.add(RecentListPdfModel.fromJson(element));
      },
    );
    return list;
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
                recentBottomSheet(context);
              },
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: getallPDFRecent(),
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
                              color: starPDF.toString().contains(snapshot
                                      .data![index].recentpdf
                                      .toString())
                                  ? Colors.blue
                                  : Colors.white,
                            ),
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      color: Colors.white,
                                      height: 300,
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
                                                snapshot.data![index].recentpdf
                                                    .toString()
                                                    .split('/')
                                                    .last,
                                                style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.8),
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
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                            leading: Icon(
                                              Icons.share,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                            onTap: () {
                                              List<String> paths = [
                                                snapshot.data![index].recentpdf
                                                    .toString()
                                              ];
                                              Share.shareFiles(paths);
                                            },
                                          ),
                                          ListTile(
                                            title: starPDF.toString().contains(
                                                    snapshot
                                                        .data![index].recentpdf
                                                        .toString())
                                                ? Text(
                                                    "Remove from favorite",
                                                    style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.8),
                                                    ),
                                                  )
                                                : Text(
                                                    "Add to favorite",
                                                    style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                            leading: starPDF
                                                    .toString()
                                                    .contains(snapshot
                                                        .data![index].recentpdf
                                                        .toString())
                                                ? Icon(
                                                    Icons.star_border,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  )
                                                : Icon(
                                                    Icons.star,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                            onTap: () async {
                                              starPDF.toString().contains(
                                                      snapshot.data![index]
                                                          .recentpdf
                                                          .toString())
                                                  ? removeFromFavorite(
                                                      context, snapshot, index)
                                                  : addFavorite(
                                                      context, snapshot, index);
                                            },
                                          ),
                                          ListTile(
                                            title: Text(
                                              "Remove from recents",
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                            leading: Icon(
                                              Icons.auto_delete,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(builder: (context) => pdfscreen()),
                                              // );
                                              await RecentSQLPDFService()
                                                  .removeFromRecent(
                                                      snapshot.data![index]
                                                          .recentpdf
                                                          .toString(),
                                                      SqlModel.tableRecent)
                                                  .whenComplete(() {
                                                setState(() {});
                                              });
                                            },
                                          ),
                                          ListTile(
                                            title: Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                            leading: Icon(
                                              Icons.delete,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                            onTap: () {
                                              deleteDialougeRecentScreen(
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
        ));
  }

  Future<void> recentBottomSheet(BuildContext context) {
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
                  "Clear Recents",
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

                  await RecentSQLPDFService()
                      .clearRecentPdfData(SqlModel.tableRecent)
                      .whenComplete(() {
                    setState(() {});
                  });
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Recent cleared !!"),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void deleteDialougeRecentScreen(BuildContext context,
      AsyncSnapshot<List<RecentListPdfModel>> snapshot, int index) {
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

            deleteMethodRecentScreen(context, snapshot, index);
          },
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert!"),
      content: Text(
          "Would you like to delete ${snapshot.data![index].recentpdf.toString().split('/').last}"),
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

  Future<void> deleteMethodRecentScreen(BuildContext context,
      AsyncSnapshot<List<RecentListPdfModel>> snapshot, int index) async {
    await RecentSQLPDFService().removeFromRecent(
        snapshot.data![index].recentpdf.toString(), SqlModel.tableRecent);
    deleteFileRecent(
      File(
        snapshot.data![index].recentpdf.toString(),
      ),
    ).whenComplete(() {});
    getFiles();
    getallPDFRecent(); // });
    showAlertDialogRecent(context, snapshot, index);
    setState(() {});
  }

  Future<void> deleteFileRecent(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  void showAlertDialogRecent(BuildContext context,
      AsyncSnapshot<List<RecentListPdfModel>> snapshot, int index) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Succesfuly deleted"),
      content: Text(snapshot.data![index].recentpdf.toString().split('/').last),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
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

  removeFromFavorite(BuildContext context,
      AsyncSnapshot<List<RecentListPdfModel>> snapshot, int index) async {
    await SQLPDFService()
        .removeFromFavorite(
            snapshot.data![index].recentpdf.toString(), SqlModel.tableFavorite)
        .whenComplete(() {
      setState(() {});
    });
    Navigator.pop(context);
    initState();
  }

  addFavorite(BuildContext context,
      AsyncSnapshot<List<RecentListPdfModel>> snapshot, int index) async {
    Map<String, Object> data = {
      'pdf': (snapshot.data![index].recentpdf.toString()),
    };
    if (!data.isEmpty) {
      try {
        await SQLPDFService().insertPDF(data, SqlModel.tableFavorite);
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
      print("pdfname is--------------> $data");
    }
    Navigator.pop(context);
    initState();
  }
}
