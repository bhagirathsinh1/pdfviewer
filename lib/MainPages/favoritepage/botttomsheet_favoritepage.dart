import 'package:flutter/material.dart';

import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/CommonWidget/delete_file_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/share_file_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/title_of_bottomsheetpdf.dart';
import 'package:provider/provider.dart';

class BottomsheetFavoritePage extends StatefulWidget {
  BottomsheetFavoritePage({
    Key? key,
    required this.index,
    required this.fileName,
  }) : super(key: key);
  final int index;
  final String fileName;

  @override
  _BottomsheetFavoritePageState createState() =>
      _BottomsheetFavoritePageState();
}

class _BottomsheetFavoritePageState extends State<BottomsheetFavoritePage> {
  @override
  Widget build(BuildContext context) {
    var paths = widget.fileName;

    var titlePath = paths.toString().split('/').last;
    return Container(
      color: Colors.white,
      height: 250,
      child: Column(
        children: [
          TitleOfPdf(titlePath: titlePath),

          //
          ShareFiles(fileName: widget.fileName, index: widget.index),

          //
          ListTile(
            title: Text(
              "Remove from favorite",
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            leading: Icon(
              Icons.star,
              color: Colors.black.withOpacity(0.5),
            ),
            onTap: () async {
              Navigator.pop(context);
              // Navigator.push(
              Provider.of<PdfFileService>(context, listen: false)
                  .removeFromFavoritePdfList(
                      paths.toString(), SqlModel.tableFavorite);
            },
          ),
          DeleteFileWidget(
            index: widget.index,
            fileName: widget.fileName,
          ),
        ],
      ),
    );
  }
}
