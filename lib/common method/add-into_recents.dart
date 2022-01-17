import 'package:flutter/material.dart';
import 'package:pdfviewer/SQLService/recent_pdf_service.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/model/pdf_list_model.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/CommonWidget/page_view.dart';
import 'package:provider/provider.dart';

class AddIntoRecents {
  addIntoRecentsMethod(
      String filePath, BuildContext context, PdfListModel pdfmodel) async {
    Map<String, Object> data = {
      'recentpdf': (filePath),
    };

    if (!data.isEmpty) {
      try {
        await RecentSQLPDFService().insertRecentPDF(data, SqlModel.tableRecent);

        Provider.of<PdfFileService>(context, listen: false).getRecentPdfList();
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
            pdfmodel: pdfmodel,
          );
        },
      ),
    );
  }
}
