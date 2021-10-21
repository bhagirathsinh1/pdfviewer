import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:gradient_progress_indicator/widget/gradient_progress_indicator_widget.dart';

import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:pdfviewer/favouritepage.dart';
import 'package:pdfviewer/recentpage.dart';
import 'package:progress_indicators/progress_indicators.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool init = false;
  bool order = false;
  List<File> files = [];

  var favorite_index;

  var recent_index;

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
    print(files);
    setState(() {}); //update the UI
  }

  @override
  void initState() {
//     files.sort((a, b) {
//   return a['name'].toLowerCase().compareTo(b['name'].toLowerCase());
// });

    if (init == true) {
    } else {
      getFiles(); //call getFiles() function on initial state.
      super.initState();
      init = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: files.isEmpty
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => searchBar()),
                        // );
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
                  ])
            : AppBar(
                title: Text(
                  "Total ${files.length} pdf found !",
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
                actions: <Widget>[
                  ///search button

                  IconButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => searchBar()),
                      // );
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
                    Text('Loading pdf'),
                    JumpingDotsProgressIndicator(
                      fontSize: 20.0,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                reverse: order,
                //if file/folder list is grabbed, then show here
                itemCount: files.length,
                itemBuilder: (BuildContext ctxt, index) {
                  return index == 0 ? _searchBar() : _listItem(index - 1);
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
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        decoration: InputDecoration(hintText: 'Search...'),
      ),
    );
  }
}
