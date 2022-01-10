import 'package:flutter/material.dart';

import 'package:pdfviewer/SQLService/sqlService.dart';

import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/CommonWidget/delete_file_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/share_file_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/title_of_bottomsheetpdf.dart';
import 'package:pdfviewer/widget/remove_from_recent.dart';
import 'package:provider/provider.dart';

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
    var paths = widget.snapshot.data![widget.index].recentpdf.toString();
    var titlePath = paths.toString().split('/').last;
    return Container(
      color: Colors.white,
      height: 300,
      child: Column(
        children: [
          TitleOfPdf(titlePath: titlePath),

          //
          ShareFiles(
              fileName: widget.fileName,
              index: widget.index,
              snapshot: widget.snapshot,
              paths: paths),

          ListTile(
            title: Provider.of<PdfFileService>(context, listen: false)
                    .starPDF
                    .toString()
                    .contains(paths)
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
            leading: Provider.of<PdfFileService>(context, listen: false)
                    .starPDF
                    .toString()
                    .contains(paths)
                ? Icon(
                    Icons.star_border,
                    color: Colors.black.withOpacity(0.5),
                  )
                : Icon(
                    Icons.star,
                    color: Colors.black.withOpacity(0.5),
                  ),
            onTap: () async {
              print(
                  "-------------${widget.snapshot.data![widget.index].recentpdf.toString()}-------------");
              if (Provider.of<PdfFileService>(context, listen: false)
                  .starPDF
                  .toString()
                  .contains(
                    paths,
                  )) {
                Provider.of<PdfFileService>(context, listen: false)
                    .removeFromFavoritePdfList(
                        paths.toString(), SqlModel.tableFavorite)
                    .whenComplete(() => Navigator.pop(context));
              } else {
                Provider.of<PdfFileService>(context, listen: false)
                    .insertIntoFavoritePdfList(paths, SqlModel.tableFavorite)
                    .whenComplete(() => Navigator.pop(context));
              }
            },
          ),
          //
          RemoveFromRecent(paths: paths),
          DeleteFileWidget(
            index: widget.index,
            fileName: widget.fileName,
          ),
        ],
      ),
    );
  }
}
