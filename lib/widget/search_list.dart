import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfviewer/SQLService/recent_pdf_service.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/widget/page_view.dart';

class SearchList extends StatefulWidget {
  SearchList({Key? key, required this.index, required this.items})
      : super(key: key);
  int index;
  List<File> items = [];
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.items[widget.index].path.split('/').last),
        leading: Icon(
          Icons.picture_as_pdf,
          color: Colors.red,
        ),
        onTap: () async {
          Map<String, Object> data = {
            'recentpdf': (widget.items[widget.index].path),
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
                  pathPDF: widget.items[widget.index].path.toString(),
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
