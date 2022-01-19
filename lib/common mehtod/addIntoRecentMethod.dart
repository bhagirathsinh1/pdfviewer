import 'package:flutter/widgets.dart';
import 'package:pdfviewer/SQLService/recent_pdf_service.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:provider/provider.dart';

class AddIntoRecentsMethod {
  Future<void> addIntoRecents(String filePath, BuildContext context) async {
    Map<String, Object> data = {
      'recentpdf': (filePath),
    };
    await RecentSQLPDFService().insertRecentPDF(data, SqlModel.tableRecent);

    Provider.of<PdfFileService>(context, listen: false).getRecentPdfList();
  }
}
