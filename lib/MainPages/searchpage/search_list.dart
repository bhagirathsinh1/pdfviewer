import 'package:flutter/material.dart';
import 'package:pdfviewer/MainPages/homepage/addremove_widget.dart';
import 'package:pdfviewer/commonmethod/commonmwthod.dart';
import 'package:pdfviewer/model/pdf_list_model.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/CommonWidget/delete_file_widget.dart';
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
      var filePath = pdfservice.files[widget.index].pdfpath.toString();
      var fileDate = pdfservice.files[widget.index].date.toString();
      var fileSize = pdfservice.files[widget.index].size.toString();
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
                            TitleOfPdf(titlePath: filePath),
                            ShareFiles(
                              fileName: filePath,
                              index: widget.index,
                            ),
                            AddRemoveWidget(paths: filePath),
                            RenameFileWidget(
                              index: widget.index,
                              fileName: filePath,
                            ),
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
            CommonAddIntoRecent().commonAddIntoRecent(
                filePath, context, pdfservice, widget.index);
          },
        ),
      );
    });
  }
}
