import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:gradient_progress_indicator/widget/gradient_progress_indicator_widget.dart';

import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:progress_indicators/progress_indicators.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var files;

  void getFiles() async {
    //asyn function to get list of files
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0]
        .rootDir; //storageInfo[1] for SD card, geting the root directory
    var fm = FileManager(root: Directory(root)); //
    files = await fm.filesTree(
        excludedPaths: ["/storage/emulated/0/Android"],
        extensions: ["pdf"] //optional, to filter files, list only pdf files
        );
    setState(() {}); //update the UI
  }

  @override
  void initState() {
    getFiles(); //call getFiles() function on initial state.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: files == null
            ? null
            : AppBar(
                title: Text("Total ${files.length} pdf found !"),
                backgroundColor: Colors.redAccent),
        body: files == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Searching pdf'),
                    JumpingDotsProgressIndicator(
                      fontSize: 20.0,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                //if file/folder list is grabbed, then show here
                itemCount: files?.length ?? 0,

                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(files[index].path.split('/').last),
                      leading: Icon(Icons.picture_as_pdf),
                      trailing: Icon(
                        Icons.more_vert,
                        color: Colors.redAccent,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ViewPDF(
                                  pathPDF: files[index].path.toString());
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
}

class ViewPDF extends StatelessWidget {
  String pathPDF = "";
  ViewPDF({required this.pathPDF});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        //view PDF
        appBar: AppBar(
          title: Text("Document"),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        path: pathPDF);
  }
}

class CircularProgressIndicatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: Colors.red,
      strokeWidth: 8,
    );
  }
}
