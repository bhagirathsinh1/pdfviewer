import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfviewer/favouritepage.dart';
import 'package:pdfviewer/main.dart';

class searchPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<searchPage> {
  TextEditingController editingController = TextEditingController();

  var items = [];

  @override
  void initState() {
    items.addAll(files);
    print("----files length----------${files.length}----------");
    print(items.length);
    super.initState();
    print(".....items length........${items.length}..................");
    print(items);
  }

  void filterSearchResults(String query) {
    List<File> dummySearchList = [];
    dummySearchList.addAll(files);
    print("......................dummysearchlist................");
    print(dummySearchList);
    if (query.isNotEmpty) {
      List<File> dummyListData = [];
      dummySearchList.forEach(
        (item) {
          if (item.path.split('/').last.toLowerCase().contains(query)) {
            dummyListData.add(item);
          }
        },
      );
      setState(
        () {
          items.clear();
          items = dummyListData;
        },
      );
      // return;
    } else {
      setState(
        () {
          items.clear();
          items.addAll(files);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
          onChanged: (value) {
            filterSearchResults(
              value.toLowerCase(),
            );
          },
          controller: editingController,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            // labelText: "Search",
            hintText: "Search Documents",
            suffixIcon: IconButton(
              onPressed: editingController.clear,
              icon: Icon(Icons.clear),
            ),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                //if file/folder list is grabbed, then show here
                itemCount: items.length,
                itemBuilder: (BuildContext ctxt, index) {
                  return _listItem(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _listItem(index) {
    return Card(
      child: ListTile(
        title: Text(items[index].path.split('/').last),
        leading: Icon(Icons.picture_as_pdf),
        // trailing: IconButton(
        //   onPressed: () {
        //     // favorite_index = index;
        //     // // recent_index = index;
        //     // bottomNavBar(context);
        //   },
        //   icon: Icon(
        //     Icons.more_vert,
        //     color: Colors.redAccent,
        //   ),
        // ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ViewPDF(
                  pathPDF: items[index].path.toString(),
                );
                //open viewPDF page on click
              },
            ),
          );
        },
      ),
    );
  }
}
