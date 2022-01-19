import 'package:flutter/material.dart';
import 'package:pdfviewer/model/pdf_list_model.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/CommonWidget/page_view.dart';

class NavigateToViewPdf {
  void navigateToViewPdf(PdfListModel pdfmodel, PdfFileService pdfservice,
      BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ViewPDF(
              pdfmodel: pdfmodel,
              callback: (String newFileName) {
                pdfservice.changeFileNameOnly(context, newFileName, index);
              });
        },
      ),
    );
  }
}
