import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfviewer/SQLService/recent_pdf_service.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/model/pdf_list_model.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/page_view.dart';
import 'package:provider/provider.dart';

class SearchList extends StatefulWidget {
  SearchList({Key? key, required this.index, required this.items})
      : super(key: key);
  int index;
  List<PdfListModel> items = [];
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PdfFileService>(builder: (context, pdfservice, child) {
      return Card(
        child: ListTile(
          title: Text(
            widget.items[widget.index].pdfname.toString(),
          ),
          subtitle: pdfservice.files[widget.index].size!.length < 7
              ? Text(
                  "${pdfservice.files[widget.index].date.toString()}\n${pdfservice.files[widget.index].size} Kb")
              : Text(
                  "${pdfservice.files[widget.index].date.toString()}\n${(double.parse(pdfservice.files[widget.index].size.toString()) / 1024).toStringAsFixed(2)} Mb"),
          leading: Icon(
            Icons.picture_as_pdf,
            color: Colors.red,
          ),
          onTap: () async {
            Map<String, Object> data = {
              'recentpdf': (widget.items[widget.index].pdfpath.toString()),
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
                    pathPDF: widget.items[widget.index].pdfpath.toString(),
                  );
                  //open viewPDF page on click
                },
              ),
            );
          },
        ),
      );
    });
  }
}
