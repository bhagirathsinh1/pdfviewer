import 'package:flutter/material.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:provider/provider.dart';

class RecentClear extends StatefulWidget {
  RecentClear({Key? key}) : super(key: key);

  @override
  _RecentClearState createState() => _RecentClearState();
}

class _RecentClearState extends State<RecentClear> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 70,
      child: Column(
        children: [
          ListTile(
            title: Text(
              "Clear Recents",
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            leading: Icon(
              Icons.delete,
              color: Colors.black.withOpacity(0.5),
            ),
            onTap: () async {
              Navigator.pop(context);

              Provider.of<PdfFileService>(context, listen: false)
                  .clearRecentPdfList(SqlModel.tableRecent);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Recent list cleared !!"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
