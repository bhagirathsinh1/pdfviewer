import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_serrvice.dart';
import 'package:pdfviewer/SQLService/recent_pdf_model.dart';

import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfviewer/main.dart';
import 'package:pdfviewer/pdf_screen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPDF extends StatefulWidget {
  String pathPDF = "";
  ViewPDF({required this.pathPDF});

  @override
  State<ViewPDF> createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  var _myFile;
  late PdfViewerController _pdfViewerController;

  TextEditingController textGotoValue = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loading();
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

  Future<List<RecentListPdfModel>> getallPDFRecent() async {
    final dbClient = await SqlModel().db;
    List<Map<String, Object?>> futurePDFList =
        await dbClient.rawQuery("Select *from ${SqlModel.tableRecent}");
    List<RecentListPdfModel> list = [];

    futurePDFList.forEach((element) {
      list.add(RecentListPdfModel.fromJson(element));
    });
    return list;
  }

  @override
  void dispose() {
    _pdfViewerController.clearSelection();
    super.dispose();
  }

  String seachValue = "";
  changePage(int index) {
    _pdfViewerController.jumpToPage(index);
  }

  loading() async {
    setState(() {
      isLoading = true;
    });

    Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        _pdfViewerController = PdfViewerController();
        _myFile = File(widget.pathPDF);
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  bool isContinuePage = false;

  @override
  Widget build(BuildContext context) {
    File filesize = File(widget.pathPDF.toString());
    var finalFileSize = filesize.lengthSync();
    var sizeInKb = (finalFileSize / (1024)).toStringAsFixed(2);

    File datefile = new File(widget.pathPDF.toString());

    var lastModDate1 = datefile.lastModifiedSync();
    var formattedDate = DateFormat('EEE, M/d/y').format(lastModDate1);
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
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SfPdfViewer.file(
                  _myFile,
                  key: _pdfViewerKey,
                  controller: _pdfViewerController,
                  pageLayoutMode: isContinuePage
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
                        height: 560,
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
                                  File(widget.pathPDF)
                                      .toString()
                                      .split('/')
                                      .last,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                                subtitle: sizeInKb.length < 7
                                    ? Text(
                                        "${formattedDate.toString()}\n${sizeInKb} Kb")
                                    : Text(
                                        "${formattedDate.toString()}\n${(finalFileSize / (1024.00 * 1024)).toStringAsFixed(2)} Mb"),
                                leading: Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.red,
                                ),
                                onTap: () {},
                              ),
                            ),
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
                                print(
                                    "---------continue page bool 1 $isContinuePage------------");
                                setState(() {
                                  isContinuePage = false;
                                  print(
                                      "----------continue page bool 2 $isContinuePage----------");
                                });
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
                                print(
                                    "---------continue page bool 1 $isContinuePage------------");
                                setState(() {
                                  isContinuePage = true;
                                  print(
                                      "----------continue page bool 2 $isContinuePage----------");
                                });
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
                              onTap: () {
                                // Future.delayed(
                                //   const Duration(seconds: 1),
                                //   () {
                                //     showGotoAlert(context);
                                //   },
                                // );
                                showGotoAlert(context);

                                // Navigator.pop(context);
                              },
                            ),
                            Divider(
                              height: 5,
                              color: Colors.grey,
                            ),
                            ListTile(
                              title: Text(
                                "Add to favorite",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              leading: Icon(
                                Icons.star_border,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              onTap: () async {
                                // Map<String, Object> data = {
                                //   'pdf': (File(widget.pathPDF).toString()),
                                // };

                                // if (!data.isEmpty) {
                                //   try {
                                //     await SQLPDFService().insertPDF(
                                //         data, SqlModel.tableFavorite);
                                //   } catch (e) {
                                //     ScaffoldMessenger.of(context)
                                //         .clearSnackBars();
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //         SnackBar(content: Text(e.toString())));
                                //   }
                                //   print("pdfname is--------------> $data");
                                // }
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
                                deleteDialougeFavoriteScreen(
                                    context, File(widget.pathPDF).toString());
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

  final _formKey = GlobalKey<FormState>();

  showGotoAlert(BuildContext context) {
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
        if (_formKey.currentState!.validate()) {
          var temp = int.parse(textGotoValue.text);
          changePage(temp);
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Go to Page"),
      content: Container(
        height: 110,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: textGotoValue,
                validator: (value) {
                  if (value != null && value != "") {
                    int temp = int.parse(value.toString());
                    if (temp > _pdfViewerController.pageNumber &&
                        temp < _pdfViewerController.pageCount) {
                      return null;
                    } else {
                      return "please enter page no between 1  - ${_pdfViewerController.pageCount}";
                    }
                  }
                },
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter Page Number '),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                    '${_pdfViewerController.pageNumber} /  ${_pdfViewerController.pageCount}',
                    style: TextStyle(
                      color: Colors.grey,
                    )),
              )
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

  deleteDialougeFavoriteScreen(BuildContext context, String string) {
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

            deleteMethodFavoriteScreen();
          },
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert!"),
      content: Text("Would you like to delete ${string.split('/').last}"),
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

  deleteMethodFavoriteScreen() async {
    await SQLPDFService().removeFromFavorite(
        File(widget.pathPDF).toString(), SqlModel.tableFavorite);
    deleteFileFavorite(
      File(File(widget.pathPDF).toString()),
    );
    print("-------string delete 1${File(widget.pathPDF).toString()}----------");

    getFiles();

    showAlertDialogFavorite(context, File(widget.pathPDF).toString());
    setState(() {});
  }

  Future<void> deleteFileFavorite(File string) async {
    print(
        "-------string delete 2 ${File(widget.pathPDF).toString()}----------");
    try {
      print("-------string delete 3 ${string}----------");

      if (await File(widget.pathPDF).exists()) {
        await File(widget.pathPDF).delete();
        print("-------string delete 4 ${string}----------");
      }
    } catch (e) {
      print(e);
    }
  }

  showAlertDialogFavorite(BuildContext context, String string) {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Succesfuly deleted"),
      content: Text(string.split('/').last),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Pdfscreen()),
            );
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
