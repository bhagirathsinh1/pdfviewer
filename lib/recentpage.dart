import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfviewer/SQLService/recent_pdf_service.dart';
import 'package:pdfviewer/SQLService/recentpdf_model.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';

import 'package:pdfviewer/main.dart';
import 'package:pdfviewer/widget/PageView.dart';
import 'package:share/share.dart';

// List<String> reversed_recent_list = [];
var arrivedataRecent;

class Recentpage extends StatefulWidget {
  const Recentpage({Key? key}) : super(key: key);

  @override
  _RecentpageState createState() => _RecentpageState();
}

class _RecentpageState extends State<Recentpage> {
  @override
  void initState() {
    super.initState();
    // reversed_recent_list = recent_list.reversed.toList();
  }

  Future<List<RecentListPdfModel>> getallPDFRecent() async {
    final dbClient = await SqlModel().db;
    List<Map<String, Object?>> futurePDFList = await dbClient.rawQuery(
      "Select *from ${SqlModel.tableRecent}",
    );
    List<RecentListPdfModel> list = [];

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
                      arrivedataRecent = snapshot.data![index].recentpdf;
                      print("dataaay is $arrivedataRecent");
                      return Card(
                        child: ListTile(
                          title: Text(
                              arrivedataRecent!.split('/').last.toString()),
                          leading: Icon(Icons.picture_as_pdf),
                          trailing: IconButton(
                            onPressed: () {
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
                                              color:
                                                  Colors.black.withOpacity(0.5),
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
                                          title: Text(
                                            "Remove from favorite",
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                            ),
                                          ),
                                          leading: Icon(
                                            Icons.star,
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
                                                    snapshot
                                                        .data![index].recentpdf
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
                                              color:
                                                  Colors.black.withOpacity(0.8),
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
                onTap: () {
                  setState(
                    () async {
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
    );
    getFiles();
    CircularProgressIndicator();
    // setState(() {
    getallPDFRecent(); // });

    // Navigator.pop(context);

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
}
