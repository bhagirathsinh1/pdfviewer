import 'package:flutter/material.dart';
import 'package:pdfviewer/MainPages/homepage/addremove_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/delete_file_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/share_file_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/title_of_bottomsheetpdf.dart';

class BottomsheetFavoritePage extends StatefulWidget {
  BottomsheetFavoritePage({
    Key? key,
    required this.fileName,
  }) : super(key: key);

  final String fileName;

  @override
  _BottomsheetFavoritePageState createState() =>
      _BottomsheetFavoritePageState();
}

class _BottomsheetFavoritePageState extends State<BottomsheetFavoritePage> {
  @override
  Widget build(BuildContext context) {
    String paths = widget.fileName;
    String titlePath = paths.toString().split('/').last;

    return Container(
      color: Colors.white,
      height: 250,
      child: Column(
        children: [
          TitleOfPdf(titlePath: titlePath),
          ShareFiles(
            fileName: paths,
          ),
          AddRemoveWidget(paths: paths),
          DeleteFileWidget(
            fileName: paths,
          ),
        ],
      ),
    );
  }
}
