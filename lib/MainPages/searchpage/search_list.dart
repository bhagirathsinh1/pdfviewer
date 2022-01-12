import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfviewer/SQLService/recent_pdf_service.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/model/pdf_list_model.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/CommonWidget/delete_file_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/page_view.dart';
import 'package:pdfviewer/widget/CommonWidget/rename_files_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/share_file_widget.dart';
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
      var isfav = pdfservice.favoritePdfList.where((element) =>
          element.pdfpath == pdfservice.files[widget.index].pdfpath.toString());
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
          trailing: Wrap(
            children: [
              Icon(
                Icons.star,
                color: !isfav.isEmpty ? Colors.blue : Colors.white,
              ),
              IconButton(
                onPressed: () {
                  var fileName =
                      pdfservice.files[widget.index].pdfpath.toString();
                  print(fileName);
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      var paths =
                          pdfservice.files[widget.index].pdfpath.toString();
                      return Container(
                        color: Colors.white,
                        height: 350,
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
                                    pdfservice.files[widget.index].pdfname
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.8),
                                    )),
                                leading: Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.red,
                                ),
                                onTap: () {},
                              ),
                            ),
                            ShareFiles(
                              fileName: fileName,
                              index: widget.index,
                            ),
                            ListTile(
                              title: !isfav.isEmpty
                                  ? Text(
                                      "Remove from favorite",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.8),
                                      ),
                                    )
                                  : Text(
                                      "Add to favorite",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.8),
                                      ),
                                    ),
                              leading: !isfav.isEmpty
                                  ? Icon(
                                      Icons.star_border,
                                      color: Colors.black.withOpacity(0.5),
                                    )
                                  : Icon(
                                      Icons.star,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                              onTap: () async {
                                print("------------------$paths-------");
                                if (!isfav.isEmpty) {
                                  pdfservice
                                      .removeFromFavoritePdfList(
                                          paths.toString(),
                                          SqlModel.tableFavorite)
                                      .whenComplete(
                                          () => Navigator.pop(context));
                                } else {
                                  pdfservice
                                      .insertIntoFavoritePdfList(
                                          paths, SqlModel.tableFavorite)
                                      .whenComplete(
                                          () => Navigator.pop(context));
                                }
                              },
                            ),
                            RenameFileWidget(
                              index: widget.index,
                              fileName: fileName,
                            ),
                            DeleteFileWidget(
                              index: widget.index,
                              fileName: fileName,
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
                  // return ViewPDF(
                  //   pathPDF: widget.items[widget.index].pdfpath.toString(),
                  // );
                  return ViewPDF(
                      pathPDF: widget.items[widget.index].pdfpath.toString(),
                      fileDate: null,
                      fileTitle: null,
                      fileSize: null,
                      filePath: null,
                      index: null);
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
