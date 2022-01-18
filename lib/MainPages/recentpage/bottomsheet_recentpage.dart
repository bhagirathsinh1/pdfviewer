import 'package:flutter/material.dart';
import 'package:pdfviewer/MainPages/homepage/addremove_widget.dart';

import 'package:pdfviewer/SQLService/sqlService.dart';

import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/CommonWidget/delete_file_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/share_file_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/title_of_bottomsheetpdf.dart';
import 'package:pdfviewer/MainPages/recentpage/remove_from_recent.dart';
import 'package:provider/provider.dart';

class BotomsheetRecentPage extends StatefulWidget {
  BotomsheetRecentPage({
    Key? key,
    required this.fileName,
  }) : super(key: key);
  final String fileName;
  @override
  _BotomsheetRecentPageState createState() => _BotomsheetRecentPageState();
}

class _BotomsheetRecentPageState extends State<BotomsheetRecentPage> {
  @override
  Widget build(BuildContext context) {
    var paths = widget.fileName;
    var titlePath = paths.toString().split('/').last;

    return Container(
      color: Colors.white,
      height: 300,
      child: Column(
        children: [
          TitleOfPdf(titlePath: titlePath),
          ShareFiles(fileName: paths),
          AddRemoveWidget(paths: paths),
          removeFromRecentPdfList(paths: paths),
          DeleteFileWidget(
            fileName: paths,
          ),
        ],
      ),
    );
  }
}
