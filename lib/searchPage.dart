// import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_file_manager/flutter_file_manager.dart';
// import 'package:gradient_progress_indicator/widget/gradient_progress_indicator_widget.dart';

// import 'package:path_provider_extention/path_provider_extention.dart';
// import 'package:pdfviewer/extra.dart';
import 'package:pdfviewer/favouritepage.dart';
import 'package:pdfviewer/main.dart';
// import 'package:pdfviewer/pdfscreen.dart';
import 'package:pdfviewer/recentpage.dart';
// import 'package:pdfviewer/serachpage.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:progress_indicators/progress_indicators.dart';

class searchPage extends StatefulWidget {
  const searchPage({Key? key}) : super(key: key);

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  TextEditingController editingController = TextEditingController();

  bool showfiles = false;
  bool myfiles = false;
  bool order = false;

  var favorite_index;

  var recent_index;

  // get files initState

  @override
  void initState() {
    setState(() {});
    super.initState();
    print("-----------------------------> called searchPage Initstate");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: Colors.white,
          title: TextField(
            controller: editingController,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: ' Search Documents',
              suffixIcon: IconButton(
                onPressed: editingController.clear,
                icon: Icon(Icons.clear),
              ),
            ),
          ),
        ),
        body: files.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        getFiles();
                        setState(() {
                          ListView.builder(
                            reverse: order,
                            //if file/folder list is grabbed, then show here
                            itemCount: files.length,
                            itemBuilder: (BuildContext ctxt, index) {
                              return _listItem(index);
                            },
                          );
                          showfiles = true;
                        });

                        // initState();
                        // initState();
                        // getFiles();

                        // // getFiles();
                        // setState(() {});

                        print("......get my files bool 1....");
                      },
                      child: showfiles ? Text("Get files") : Text("Reload Pdf"),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                reverse: order,
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
          child: Text("Date"),
          value: 1,
        ),
        PopupMenuItem(
          child: Text("Name"),
          value: 2,
        ),
        PopupMenuItem(
          child: Text("Size"),
          value: 3,
        )
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
    return Card(
      child: ListTile(
        title: Text(files[index].path.split('/').last),
        leading: Icon(Icons.picture_as_pdf),
        trailing: IconButton(
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
        onTap: () {
          print("......................");
          print(recent_list);
          print("......................");

          print(reversed_recent_list);
          print("......................");

          recent_index = index;

          // recent_list.add(files[recent_index].path);

          // print(".......recent list.......");
          // print(recent_list);
          // recent_list.add(files[recent_index].path);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ViewPDF(
                  pathPDF: files[index].path.toString(),
                );
                //open viewPDF page on click
              },
            ),
          ).whenComplete(() {
            recent_list.add(files[recent_index].path);
          });
          // recent_list.add(files[recent_index].path);
          print(".......recent list.......");
          print(recent_list);
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
                  setState(() {
                    order = !order;
                  });
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
                onTap: () {
                  if (favorite_list.contains(files[favorite_index].path)) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Already added !!"),
                      ),
                    );
                  } else {
                    favorite_list.add(files[favorite_index].path);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Successfully added !!"),
                      ),
                    );
                  }
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
                  print(
                      "...................gesture clicked.......................");
                  files.removeAt(favorite_index);
                  Navigator.pop(context);
                  initState();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // _searchBar() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8),
  //     child: TextField(
  //       decoration: InputDecoration(hintText: 'Search...'),
  //       onChanged: (text) {
  //         text = text.toLowerCase();
  //         setState(() {});
  //       },
  //     ),
  //   );
  // }
}
