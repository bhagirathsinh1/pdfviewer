import 'package:flutter/material.dart';

import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/dialogue/delete_dialouge.dart';
import 'package:pdfviewer/home_page.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/delete_file.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class BotomsheetRecentPage extends StatefulWidget {
  BotomsheetRecentPage(
      {Key? key,
      required this.index,
      required this.fileName,
      required this.snapshot})
      : super(key: key);
  final int index;
  final String fileName;
  final snapshot;
  @override
  _BotomsheetRecentPageState createState() => _BotomsheetRecentPageState();
}

class _BotomsheetRecentPageState extends State<BotomsheetRecentPage> {
  @override
  Widget build(BuildContext context) {
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
                widget.snapshot.data![widget.index].recentpdf
                    .toString()
                    .split('/')
                    .last,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              leading: Icon(
                Icons.picture_as_pdf,
                color: Colors.red,
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
              List<String> paths = [
                widget.snapshot.data![widget.index].recentpdf.toString()
              ];
              Share.shareFiles(paths);
            },
          ),
          ListTile(
            title: Homepage.starPDF.toString().contains(
                    widget.snapshot.data![widget.index].recentpdf.toString())
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
            leading: Homepage.starPDF.toString().contains(
                    widget.snapshot.data![widget.index].recentpdf.toString())
                ? Icon(
                    Icons.star_border,
                    color: Colors.black.withOpacity(0.5),
                  )
                : Icon(
                    Icons.star,
                    color: Colors.black.withOpacity(0.5),
                  ),
            onTap: () async {
              Homepage.starPDF.toString().contains(
                        widget.snapshot.data![widget.index].recentpdf
                            .toString(),
                      )
                  ? Provider.of<PdfFileService>(context, listen: false)
                      .removeFromFavorite(
                          context, widget.snapshot, widget.index)
                  //
                  : Provider.of<PdfFileService>(context, listen: false)
                      .addFavorite(context, widget.snapshot, widget.index);
            },
          ),
          ListTile(
            title: Text(
              "Remove from recents",
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            leading: Icon(
              Icons.auto_delete,
              color: Colors.black.withOpacity(0.5),
            ),
            onTap: () async {
              Navigator.pop(context);

              Provider.of<PdfFileService>(context, listen: false)
                  .removeFromRecent(
                      widget.snapshot.data![widget.index].recentpdf.toString(),
                      SqlModel.tableRecent);
            },
          ),
          DeleteFileWidget(
            onTap: () {
              var fileName =
                  widget.snapshot.data![widget.index].recentpdf.toString();

              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return new DeleteFileDialouge(
                      index: widget.index,
                      fileName: fileName,
                    );
                  });
            },
            index: widget.index,
            fileName: widget.fileName,
          ),
        ],
      ),
    );
  }
}
