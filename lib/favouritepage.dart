import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:pdfviewer/homepage.dart';
import 'package:pdfviewer/main.dart';
import 'package:share/share.dart';
import 'package:snapping_page_scroll/snapping_page_scroll.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
var brightness = SchedulerBinding.instance!.window.platformBrightness;
bool isDarkMode = brightness == Brightness.dark;

var bgColor = isDarkMode ? Colors.black : Colors.white;

List<String> favorite_list = [];
// List<String> reversed_favorite_list = [];

class Favouritepage extends StatefulWidget {
  const Favouritepage({Key? key}) : super(key: key);

  @override
  _FavouritepageState createState() => _FavouritepageState();
}

class _FavouritepageState extends State<Favouritepage> {
  @override
  void initState() {
    super.initState();
    // reversed_favorite_list = favorite_list.reversed.toList();
  }

  var newindex;

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
      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          //if file/folder list is grabbed, then show here
          itemCount: favorite_list.length,
          reverse: true,

          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(favorite_list[index].split('/').last),
                leading: Icon(Icons.picture_as_pdf),
                trailing: IconButton(
                  onPressed: () {
                    newindex = index;
                    favNavDrawer(context);
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
                          pathPDF: favorite_list[index].toString(),
                        );
                        //open viewPDF page on click
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> favNavDrawer(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
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
                    favorite_list[newindex].split('/').last,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  leading: Icon(
                    Icons.picture_as_pdf,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  onTap: () {},
                ),
              ),
              ListTile(
                title: Text(
                  "Share",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.share,
                  color: Colors.black.withOpacity(0.5),
                ),
                onTap: () {
                  List<String> paths = [files[favorite_index].path];
                  Share.shareFiles(paths);
                },
              ),
              ListTile(
                title: Text(
                  "Remove from favorite",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.star,
                  color: Colors.black.withOpacity(0.5),
                ),
                onTap: () {
                  setState(
                    () {
                      favorite_list.removeAt(newindex);

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Remove from favorites !!"),
                        ),
                      );
                    },
                  );
                },
              ),
              ListTile(
                title: Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.delete,
                  color: Colors.black.withOpacity(0.5),
                ),
                onTap: () {},
              ),
            ],
          ),
        );
      },
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
                onTap: () {
                  setState(
                    () {
                      favorite_list.clear();
                      // reversed_favorite_list.clear();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Favorites cleared !!")));
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
            // leading: IconButton(
            //   color: Colors.black,
            //   icon: new Icon(Icons.search),
            //   highlightColor: Colors.pink,
            //   onPressed: () {
            //     if (dark == true) {
            //       dark = false;
            //     } else {
            //       dark = true;
            //     }
            //     // setState(() {
            //     changeBackground();
            //     // });
            //   },
            // ),
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
                                // print(
                                //     "---------page by page bool 1 $continuePageBool------------");

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
                              onTap: () {},
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

  void changeBackground() {
    if (dark == true) {
      bgColor = Colors.black;
    } else {
      bgColor = Colors.white;
    }
  }
}
