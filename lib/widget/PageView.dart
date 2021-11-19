import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void dispose() {
    _pdfViewerController.clearSelection();
    super.dispose();
  }

  String seachvalue = "";
  changePage(int index) {
    _pdfViewerController.jumpToPage(index);
  }

  loading() async {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () async {
      _pdfViewerController = PdfViewerController();
      _myFile = File(widget.pathPDF);
      setState(() {
        isLoading = false;
      });
    });
  }

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
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SfPdfViewer.file(
                  _myFile,
                  key: _pdfViewerKey,
                  controller: _pdfViewerController,
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
                                print(
                                    "---------continue page bool 1 $continuePageBool------------");
                                setState(() {
                                  continuePageBool = false;
                                  print(
                                      "----------continue page bool 2 $continuePageBool----------");
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
                                    "---------continue page bool 1 $continuePageBool------------");
                                setState(() {
                                  continuePageBool = true;
                                  print(
                                      "----------continue page bool 2 $continuePageBool----------");
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
        height: 80,
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
}
