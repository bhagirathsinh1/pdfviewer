// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/CommonWidget/title_of_bottomsheetpdf.dart';
import 'package:pdfviewer/widget/CommonWidget/viewpdf/continue_page.dart';
import 'package:pdfviewer/widget/CommonWidget/viewpdf/nightmode.dart';
import 'package:pdfviewer/widget/CommonWidget/viewpdf/page_by_page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BrowsMoreView extends StatefulWidget {
  String path;
  BrowsMoreView({
    required this.path,
  });

  @override
  State<BrowsMoreView> createState() => _ViewPDFState();
}

class _ViewPDFState extends State<BrowsMoreView> {
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

  String seachValue = "";
  changePage(int index) {
    _pdfViewerController.jumpToPage(index);
  }

  loading() async {
    setState(() {
      isLoading = true;
    });

    Future.delayed(
      const Duration(milliseconds: 300),
      () async {
        _pdfViewerController = PdfViewerController();
        _myFile = File(widget.path.toString());
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  bool isContinuePage = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfFileService>(builder: (context, pdfservice, child) {
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
                : Theme(
                    data: ThemeData.light(),
                    child: SfPdfViewer.file(
                      _myFile,
                      key: _pdfViewerKey,
                      controller: _pdfViewerController,
                      pageLayoutMode: isContinuePage
                          ? PdfPageLayoutMode.single
                          : PdfPageLayoutMode.continuous,
                    ),
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
                          height: 320,
                          child: Column(
                            children: [
                              TitleOfPdf(
                                  titlePath:
                                      widget.path.toString().split('/').last),
                              ContinuePage(
                                isContinuePage: isContinuePage,
                                onValueChanged: (bool value) {
                                  setState(() {
                                    isContinuePage = value;
                                  });
                                },
                              ),
                              PageByPage(
                                isContinuePage: isContinuePage,
                                onValueChanged: (bool value) {
                                  setState(() {
                                    isContinuePage = value;
                                  });
                                },
                              ),
                              NightMode(),
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
                                  showGotoAlert(context);
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
    });
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
                    if (temp >= _pdfViewerController.pageNumber &&
                        temp <= _pdfViewerController.pageCount) {
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
