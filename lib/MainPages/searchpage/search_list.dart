import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfviewer/MainPages/homepage/addremove_widget.dart';
import 'package:pdfviewer/SQLService/recent_pdf_service.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/model/pdf_list_model.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/CommonWidget/delete_file_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/page_view.dart';
import 'package:pdfviewer/widget/CommonWidget/rename_files_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/share_file_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/title_of_bottomsheetpdf.dart';
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
      var fileIndex = pdfservice.files[widget.index];
      var filePath = fileIndex.pdfpath.toString();
      var fileDate = fileIndex.date.toString();
      var fileSize = fileIndex.size.toString();
      var fileTitle = fileIndex.pdfname.toString();
      var isfav = pdfservice.favoritePdfList.where((element) =>
          element.pdfpath == pdfservice.files[widget.index].pdfpath.toString());
      return Card(
        child: ListTile(
          title: Text(
            widget.items[widget.index].pdfname.toString(),
          ),
          subtitle: fileSize.length < 7
              ? Text("${fileDate}\n${fileSize} Kb")
              : Text(
                  "${fileDate}\n${(double.parse(fileSize.toString()) / 1024).toStringAsFixed(2)} Mb"),
          leading: Icon(
            Icons.picture_as_pdf,
            color: Colors.red,
          ),
          trailing: Wrap(
            children: [
              Icon(
                Icons.star,
                color: !isfav.isEmpty ? Colors.blue : Colors.white,
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        color: Colors.white,
                        height: 350,
                        child: Column(
                          children: [
                            TitleOfPdf(titlePath: fileTitle),
                            ShareFiles(
                              fileName: filePath,
                              index: widget.index,
                            ),
                            AddRemoveWidget(paths: filePath),
                            RenameFileWidget(
                                index: widget.index,
                                fileName: filePath,
                                callback: (String newFileName) {
                                  pdfservice.changeFileNameOnly(
                                      context, newFileName, widget.index);
                                }),
                            DeleteFileWidget(
                              index: widget.index,
                              fileName: filePath,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          onTap: () async {
            Map<String, Object> data = {
              'recentpdf': (filePath),
            };

            if (!data.isEmpty) {
              try {
                await RecentSQLPDFService()
                    .insertRecentPDF(data, SqlModel.tableRecent);

                Provider.of<PdfFileService>(context, listen: false)
                    .getRecentPdfList();
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
                    pdfmodel: pdfservice.files[widget.index],
                  );
                },
              ),
            );
          },
        ),
      );
    });
  }
}
