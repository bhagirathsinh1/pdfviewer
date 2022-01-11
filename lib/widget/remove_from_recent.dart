import 'package:flutter/material.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/service/recent_screen_service.dart';
import 'package:provider/provider.dart';

class removeFromRecentPdfList extends StatelessWidget {
  final String paths;

  const removeFromRecentPdfList({Key? key, required this.paths})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
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
            .removeFromRecentPdfList(paths, SqlModel.tableRecent);
      },
    );
  }
}
