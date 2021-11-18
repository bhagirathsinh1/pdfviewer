import 'dart:io';
// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:pdfviewer/SQLService/add_pdf_serrvice.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/SQLService/sql_model.dart';
import 'package:pdfviewer/homepage.dart';
import 'package:pdfviewer/main.dart';
import 'package:pdfviewer/pdfscreen.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
var brightness = SchedulerBinding.instance!.window.platformBrightness;
bool isDarkMode = brightness == Brightness.dark;

var bgColor = isDarkMode ? Colors.black : Colors.white;
var arrivedata;

// List<String> favorite_list = [];
// var newindex;

// List<String> reversed_favorite_list = [];

class Favouritepage extends StatefulWidget {
  const Favouritepage({Key? key}) : super(key: key);

  @override
  _FavouritepageState createState() => _FavouritepageState();
}

class _FavouritepageState extends State<Favouritepage> {
  @override
  void initState() {
    setState(() {});
    // getallPDF();

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
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    arrivedata = snapshot.data![index].pdf;
                    print("dataaay is $arrivedata");
                    return Card(
                      child: ListTile(
                        title: Text(arrivedata!.split('/').last.toString()),
                        leading: Icon(Icons.picture_as_pdf),
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
                                              .whenComplete(() => initState());
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ViewPDF(
                                  pathPDF: snapshot.data![index].pdf.toString(),
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
                      .whenComplete(
                        () => initState(),
                      );
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
        Navigator.pop(context);

        deleteMethodFavoriteScreen(context, snapshot, index);
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
    );
    getFiles();
    CircularProgressIndicator();
    // setState(() {
    getallPDF(); // });

    // Navigator.pop(context);

    showAlertDialogFavorite(context, snapshot, index);

    initState();
    initState();
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
            initState();
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

class ViewPDF extends StatefulWidget {
  String pathPDF = "";
  ViewPDF({required this.pathPDF});

  @override
  State<ViewPDF> createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> {
  bool dark = true;

  bool continuePageBool = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              "PDF Reader",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
          ),
          body: SfPdfViewer.file(
            File(widget.pathPDF),
            pageLayoutMode: continuePageBool
                ? PdfPageLayoutMode.single
                : PdfPageLayoutMode.continuous,
          ),
        ),
        Positioned(
          bottom: 15,
          right: 15,
          child: FloatingActionButton(
            // elevation: 0,
            onPressed: () {},
            child: IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        color: Colors.white,
                        height: 500,
                        child: Column(
                          children: [
                            // Container(
                            //   decoration: BoxDecoration(
                            //       color: Colors.yellow[100],
                            //       border: Border.all(
                            //         color: Colors.grey,
                            //         width: 5,
                            //       )),
                            //   child: ListTile(
                            //     title: Text(
                            //       reversed_favorite_list[newindex]
                            //           .split('/')
                            //           .last,
                            //       style: TextStyle(
                            //         color: Colors.black.withOpacity(0.8),
                            //       ),
                            //     ),
                            //     leading: Icon(
                            //       Icons.picture_as_pdf,
                            //       color: Colors.black.withOpacity(0.5),
                            //     ),
                            //     onTap: () {},
                            //   ),
                            // ),
                            ListTile(
                              title: Text(
                                "Continuous page",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              leading: IconButton(
                                icon: new Icon(Icons.print_outlined),
                                color: Colors.black.withOpacity(0.5),
                                onPressed: () {},
                              ),
                              onTap: () {
                                // print(
                                //     "---------continue page bool 1 $continuePageBool------------");
                                // setState(() {
                                //   continuePageBool = true;
                                //   print(
                                //       "----------continue page bool 2 $continuePageBool----------");
                                // });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: Text(
                                "Page by page",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              leading: Icon(
                                Icons.call_to_action_rounded,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              onTap: () {
                                // print(                                //     "---------page by page bool 1 $continuePageBool------------");

                                // setState(() {
                                //   continuePageBool = false;
                                //   print(
                                //       "---------page by page bool 2 $continuePageBool------------");
                                // });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: Text(
                                "Night Mode",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              leading: Icon(
                                Icons.nights_stay,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              onTap: () {},
                            ),
                            ListTile(
                              title: Text(
                                "Go to page",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              leading: Icon(
                                Icons.screen_search_desktop_rounded,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              onTap: () {},
                            ),
                            Divider(
                              height: 5,
                              color: Colors.grey,
                            ),
                            ListTile(
                              title: Text(
                                "Remove from favorite",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              leading: Icon(
                                Icons.star_border,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              onTap: () {},
                            ),
                            ListTile(
                              title: Text(
                                "Rename",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              leading: Icon(
                                Icons.drive_file_rename_outline_outlined,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              onTap: () {},
                            ),
                            ListTile(
                              title: Text(
                                "Print",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              leading: Icon(
                                Icons.local_print_shop_rounded,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              onTap: () {},
                            ),
                            ListTile(
                              title: Text(
                                "Delete",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              leading: Icon(
                                Icons.delete_rounded,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              onTap: () {
                                // newshowAlertDialogOpenPdf(context);
                                print('--------------delete clicked---------');
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.settings),
            ),
          ),
        ),
      ],
    );
  }
}
