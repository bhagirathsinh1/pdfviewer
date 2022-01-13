import 'package:flutter/material.dart';
import 'package:pdfviewer/model/pdf_list_model.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/MainPages/searchpage/search_list.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<SearchPage> {
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfFileService>(
      builder: (context, pdfservice, child) {
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
                    itemCount: pdfservice.items.length,
                    itemBuilder: (BuildContext ctxt, index) {
                      return SearchList(
                        items: pdfservice.items,
                        index: index,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void filterSearchResults(String query) {
    var pdfservice = Provider.of<PdfFileService>(context, listen: false);
    List<PdfListModel> dummySearchList = [];
    dummySearchList.addAll(pdfservice.files);

    if (query.isNotEmpty) {
      List<PdfListModel> dummyListData = [];
      dummySearchList.forEach(
        (item) {
          if (item.pdfname!.toLowerCase().contains(query)) {
            dummyListData.add(item);
          }
        },
      );
      setState(
        () {
          pdfservice.items.clear();
          pdfservice.items = dummyListData;
        },
      );
    } else {
      setState(
        () {
          pdfservice.items.clear();
          pdfservice.items.addAll(pdfservice.files);
        },
      );
    }
  }
}
