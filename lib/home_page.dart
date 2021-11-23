import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_serrvice.dart';
import 'package:pdfviewer/SQLService/recent_pdf_service.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';

import 'package:pdfviewer/main.dart';
import 'package:pdfviewer/search_page.dart';
import 'package:pdfviewer/widget/page_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

import 'main.dart';

// bool favoritestar = false;

var favorite_index;
enum SingingCharacter {
  isSizeAccendingRadio,
  isSizeDeccendingRadio,
  nameRadio,
  dateRadio
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  SingingCharacter? _character;

  String? formattedDate;
  var finalFileSize;
  bool isReverseSized = false;
  bool isShowFiles = false;
  bool isMyFiles = false;
  bool isNameSort = false;
  bool isDateSort = false;
  bool isSizeAccending = false;
  bool isSizeDeccending = false;

  @override
  void initState() {
    // setState(() {});
    super.initState();
    print("-----------------------------> called homepage Initstate");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: Permission.storage.request().isGranted == true
            ? AppBar(
                title: Text(
                  "PDF Reader",
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
                actions: <Widget>[
                  ///search button

                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage()),
                      );
                    },
                    icon: Icon(
                      Icons.search,
                      size: 26.0,
                      color: Colors.black,
                    ),
                  ),

                  ///popupmanu

                  popUpMenu(),

                  ///more

                  IconButton(
                    onPressed: () {
                      bottmNavBar(context);
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
            : AppBar(
                title: Text(
                  " ${files.length} pdf found !",
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
                actions: <Widget>[
                  ///search button

                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage()),
                      );
                    },
                    icon: Icon(
                      Icons.search,
                      size: 26.0,
                      color: Colors.black,
                    ),
                  ),

                  ///popupmanu

                  popUpMenu(),

                  ///more

                  IconButton(
                    onPressed: () {
                      bottmNavBar(context);
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
        body: files.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        getFiles();

                        ListView.builder(
                          //if file/folder list is grabbed, then show here
                          itemCount: files.length,
                          itemBuilder: (BuildContext ctxt, index) {
                            return _listItem(index);
                          },
                        );
                        isShowFiles = true;

                        print("......get my files bool 1....");
                      },
                      child:
                          isShowFiles ? Text("Get files") : Text("Reload Pdf"),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                reverse: isReverseSized,
                //if file/folder list is grabbed, then show here
                itemCount: files.length,
                itemBuilder: (BuildContext ctxt, index) {
                  return _listItem(index);
                },
              ),
      ),
    );
  }

  PopupMenuButton<int> popUpMenu() {
    return PopupMenuButton(
      icon: Icon(
        Icons.menu,
        color: Colors.black,
      ),
      color: Colors.white,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Row(
            children: [
              Radio<SingingCharacter>(
                value: SingingCharacter.isSizeAccendingRadio,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  if (isSizeAccending == false) {
                    try {
                      Future.delayed(
                        const Duration(milliseconds: 200),
                        () async {
                          files.sort(
                            (b, a) {
                              return a.lengthSync().compareTo(b.lengthSync());
                            },
                          );
                        },
                      );
                    } catch (e) {
                      print('-------------------> error ---> $e');
                    }
                  }
                  setState(
                    () {
                      _character = value;
                      isReverseSized = true;
                      isSizeAccending = true;
                      isSizeDeccending = false;
                      isNameSort = false;
                      isDateSort = false;
                    },
                  );
                  Navigator.pop(context);
                },
              ),
              Text("Size : Accending")
            ],
          ),
          value: 1,
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Radio<SingingCharacter>(
                value: SingingCharacter.isSizeDeccendingRadio,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  if (isSizeDeccending == false) {
                    try {
                      Future.delayed(
                        const Duration(milliseconds: 200),
                        () async {
                          files.sort(
                            (b, a) {
                              return a.lengthSync().compareTo(b.lengthSync());
                            },
                          );
                        },
                      );
                    } catch (e) {
                      print('-------------------> error ---> $e');
                    }
                  }
                  setState(() {
                    _character = value;
                    isReverseSized = false;
                    isSizeDeccending = true;
                    isSizeAccending = false;
                    isNameSort = false;
                    isDateSort = false;
                  });
                  Navigator.pop(context);
                },
              ),
              Text("Size : Deccending")
            ],
          ),
          value: 2,
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Radio<SingingCharacter>(
                value: SingingCharacter.nameRadio,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  if (isNameSort == false) {
                    print("...........files1..................");
                    print(files);

                    try {
                      Future.delayed(
                        const Duration(milliseconds: 200),
                        () async {
                          files.sort(
                            (a, b) {
                              return a.path
                                  .split('/')
                                  .last
                                  .compareTo(b.path.split('/').last);
                            },
                          );
                        },
                      );
                    } catch (e) {
                      print('-------------------> error ---> $e');
                    }
                  }
                  setState(
                    () {
                      _character = value;
                      isReverseSized = false;
                      isSizeAccending = false;
                      isSizeDeccending = false;
                      isNameSort = true;
                      isDateSort = false;
                    },
                  );
                  Navigator.pop(context);
                },
              ),
              Text("Name")
            ],
          ),
          value: 3,
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Radio<SingingCharacter>(
                value: SingingCharacter.dateRadio,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  if (isDateSort == false) {
                    try {
                      Future.delayed(
                        const Duration(milliseconds: 200),
                        () async {
                          files.sort(
                            (b, a) {
                              return a
                                  .lastModifiedSync()
                                  .compareTo(b.lastModifiedSync());
                            },
                          );
                        },
                      );
                    } catch (e) {
                      print('-------------------> error ---> $e');
                    }
                  }
                  setState(
                    () {
                      _character = value;
                      isReverseSized = false;
                      isSizeAccending = false;
                      isSizeDeccending = false;
                      isDateSort = true;
                      isNameSort = false;
                    },
                  );
                  Navigator.pop(context);
                },
              ),
              Text("Date")
            ],
          ),
          value: 4,
        ),
      ],
    );
  }

  Future<void> bottmNavBar(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 230,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  "Brows More file",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.folder,
                  color: Colors.black.withOpacity(0.5),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  "Rate Us",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.star,
                  color: Colors.black.withOpacity(0.5),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  "Share this app",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.share,
                  color: Colors.black.withOpacity(0.5),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  "Privacy Policy",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.privacy_tip,
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

  _listItem(index) {
    File filesize = File(
      files[index].path.toString(),
    );
    finalFileSize = filesize.lengthSync();
    var sizeInKb = (finalFileSize / (1024)).toStringAsFixed(2);

    File datefile = new File(
      files[index].path.toString(),
    );

    var lastModDate1 = datefile.lastModifiedSync();
    formattedDate = DateFormat('EEE, M/d/y').format(lastModDate1);
    ;
    print("....................file size.........................");
    print('Mb ${sizeInKb}');
    return Card(
      child: ListTile(
        title: Text(files[index].path.split('/').last),
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
            // IconButton(
            //   onPressed: () {
            //     // favorite_index = index;
            //     // // recent_index = index;
            //     // bottomNavBar(context);
            //   },
            //   icon: Icon(
            //     Icons.star,
            //     color: Colors.blue,
            //   ),
            // ),
            IconButton(
              onPressed: () {
                favorite_index = index;
                // recent_index = index;
                bottomNavBar(context);
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
            'recentpdf': (files[index].path),
          };

          if (!data.isEmpty) {
            try {
              await RecentSQLPDFService()
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
                  pathPDF: files[index].path,
                );
                //open ViewPDFHomeScreen page on click
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> bottomNavBar(BuildContext context) {
    return showModalBottomSheet<void>(
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
                    files[favorite_index].path.split('/').last,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
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
                  "Add to favorite",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.star,
                  color: Colors.black.withOpacity(0.5),
                ),
                onTap: () async {
                  Map<String, Object> data = {
                    'pdf': (files[favorite_index].path),
                  };

                  if (!data.isEmpty) {
                    try {
                      await SQLPDFService()
                          .insertPDF(data, SqlModel.tableFavorite);
                    } catch (e) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                    print("pdfname is--------------> $data");
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  "Rename",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.edit,
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
                  Icons.delete,
                  color: Colors.black.withOpacity(0.5),
                ),
                onTap: () {
                  newshowAlertDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> deleteFile(File file) async {
    print(
        "-------string delete 2 homepage${files[favorite_index].path.toString()}----------");
    try {
      print(
          "-------string delete 3 homepage${files[favorite_index].path.toString()}----------");
      if (await file.exists()) {
        await file.delete();
        print(
            "-------string delete 4 homepage${files[favorite_index].path.toString()}----------");
      }
    } catch (e) {
      print(e);
    }
  }

  deleteMethod() {
    deleteFile(
      File(
        files[favorite_index].path.toString(),
      ),
    ).whenComplete(
        () => {getFiles(), showAlertDialog(context), setState(() {})});

    // );
  }

  newshowAlertDialog(BuildContext context) {
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

            deleteMethod();
          },
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert!"),
      content: Text(
          "Would you like to delete ${files[favorite_index].path.split('/').last}"),
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

  showAlertDialog(BuildContext context) {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Succesfuly deleted"),
      content: Text(files[favorite_index].path.split('/').last),
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
