import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_model.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_serrvice.dart';
import 'package:pdfviewer/SQLService/recent_pdf_model.dart';
import 'package:pdfviewer/SQLService/recent_pdf_service.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';

import 'package:pdfviewer/main.dart';
import 'package:pdfviewer/search_page.dart';
import 'package:pdfviewer/widget/page_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

import 'main.dart';

late List starPDF = [];

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
  TextEditingController textGotoValue = TextEditingController();

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
    getallPDF();
    // setState(() {});
    super.initState();
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
                // reverse: isReverseSized,
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
                              return b.lengthSync().compareTo(a.lengthSync());
                            },
                          );
                        },
                      ).whenComplete(() {
                        setState(() {});
                      });
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
                      ).whenComplete(() {
                        setState(() {});
                      });
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
                      ).whenComplete(() {
                        setState(() {});
                      });
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
                      ).whenComplete(() {
                        setState(() {});
                      });
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
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );
                  print(
                      "------picked file--->/${result!.files.single.path.toString()}------");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ViewPDF(
                          pathPDF: result.files.single.path.toString(),
                        );

                        //open ViewPDFHomeScreen page on click
                      },
                    ),
                  );

                  print("---------picked file--------->$result---------------");
                },
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
    print("------------check file----------${files[index]}----------------");
    print(
        "------------check file path----------${files[index].path}----------------");
    print(
        "------------check file  string----------${files[index].path.toString()}----------------");

    // print("------------star pdf file----------${starPDF[0]}----------------");

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
            Icon(
              Icons.star,
              color: starPDF.toString().contains(files[index].path.toString())
                  ? Colors.blue
                  : Colors.white,
            ),
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
                title: starPDF
                        .toString()
                        .contains(files[favorite_index].path.toString())
                    ? Text(
                        "Remove from favorite",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                        ),
                      )
                    : Text(
                        "Add to favorite",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                leading: starPDF
                        .toString()
                        .contains(files[favorite_index].path.toString())
                    ? Icon(
                        Icons.star_border,
                        color: Colors.black.withOpacity(0.5),
                      )
                    : Icon(
                        Icons.star,
                        color: Colors.black.withOpacity(0.5),
                      ),
                onTap: () async {
                  starPDF
                          .toString()
                          .contains(files[favorite_index].path.toString())
                      ? removeFromFavorite()
                      : addFavorite();
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
                onTap: () {
                  showAlertDialogRenameFile(context);
                  // removeFromFavorite();
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
          const Duration(milliseconds: 200),
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

  removeFromFavorite() async {
    await SQLPDFService()
        .removeFromFavorite(files[favorite_index].path.toString().toString(),
            SqlModel.tableFavorite)
        .whenComplete(() {
      setState(() {});
    });
  }

  removeFromRecent() async {
    await RecentSQLPDFService()
        .removeFromRecent(files[favorite_index].path.toString().toString(),
            SqlModel.tableRecent)
        .whenComplete(() {
      setState(() {});
    });
    Navigator.pop(context);
    initState();
  }

  addFavorite() async {
    Map<String, Object> data = {
      'pdf': (files[favorite_index].path),
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

  final _formKeyRenameFile = GlobalKey<FormState>();

  showAlertDialogRenameFile(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("CANCEL"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        var newFileName = textGotoValue.text;

        Future.delayed(
          const Duration(milliseconds: 1),
          () async {
            changeFileNameOnly(context, newFileName);
            Navigator.pop(context);
          },
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Rename File"),
      content: Container(
        height: 90,
        child: Form(
          key: _formKeyRenameFile,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: textGotoValue,
                validator: (value) {
                  if (value != null && value != "") {
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
                // Only numbers can be entered
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter new name here '),
              ),
            ],
          ),
        ),
      ),
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

  changeFileNameOnly(BuildContext context, String newFileName) {
    print("------------->arrived new name----$newFileName--------");
    var pathOfFile = files[favorite_index].path.toString();
    var lastSeparator = pathOfFile.lastIndexOf(Platform.pathSeparator);
    var newPath =
        pathOfFile.substring(0, lastSeparator + 1) + newFileName + ".pdf";
    print("-------------pathOfFile---------->$pathOfFile---------");
    print(
        "-------------files[favorite_index]---------->${files[favorite_index]}---------");

    print("-------------lastSeparator---------->$lastSeparator---------");
    print("-------------newPath---------->$newPath---------");
    print(
        "-------------return data-------${files[favorite_index].rename(newPath).toString()}-------");

    Future<File> temp = files[favorite_index].rename(newPath);
    temp.then(
      (v) {
        print("-------------v.path data---------------- ${v.path}");

        setState(
          () {
            files[favorite_index] = v;

            print(
                "-------------files path data---------------- ${files[favorite_index]}");
          },
        );
      },
    ).whenComplete(() {
      getFiles();
    }).whenComplete(() {
      initState();
    }).whenComplete(() {
      removeFromFavorite();
    }).whenComplete(() {
      removeFromRecent();
    }).whenComplete(() {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Renamed to  ${newFileName}")));
      setState(() {});
    });
  }
}
