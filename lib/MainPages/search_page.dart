import 'dart:io';

import 'package:flutter/material.dart';

import 'package:pdfviewer/main.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/search_list.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<SearchPage> {
  TextEditingController editingController = TextEditingController();

  List<File> items = [];

  @override
  void initState() {
    items.addAll(Provider.of<PdfFileService>(context, listen: false).files);
    print(
        "----files length----------${Provider.of<PdfFileService>(context, listen: false).files.length}----------");
    print(items.length);
    super.initState();
    print(".....items length........${items.length}..................");
    print(items);
  }

  void filterSearchResults(String query) {
    List<File> dummySearchList = [];
    dummySearchList
        .addAll(Provider.of<PdfFileService>(context, listen: false).files);
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
          items.addAll(
              Provider.of<PdfFileService>(context, listen: false).files);
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
                  return SearchList(
                    items: items,
                    index: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}