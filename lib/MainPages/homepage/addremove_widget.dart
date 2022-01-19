import 'package:flutter/material.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/model/pdf_list_model.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:provider/provider.dart';

class AddRemoveWidget extends StatefulWidget {
  AddRemoveWidget({Key? key, required this.paths}) : super(key: key);
  final String paths;
  @override
  _AddRemoveWidgetState createState() => _AddRemoveWidgetState();
}

class _AddRemoveWidgetState extends State<AddRemoveWidget> {
  @override
  Widget build(BuildContext context) {
    PdfFileService pdfService =
        Provider.of<PdfFileService>(context, listen: false);
    Iterable<PdfListModel> isfav = pdfService.favoritePdfList
        .where((element) => element.pdfpath == widget.paths);
    return ListTile(
      title: !isfav.isEmpty
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
      leading: !isfav.isEmpty
          ? Icon(
              Icons.star_border,
              color: Colors.black.withOpacity(0.5),
            )
          : Icon(
              Icons.star,
              color: Colors.black.withOpacity(0.5),
            ),
      onTap: () async {
        if (!isfav.isEmpty) {
          pdfService
              .removeFromFavoritePdfList(
                  widget.paths.toString(), SqlModel.tableFavorite)
              .whenComplete(() => Navigator.pop(context));
        } else {
          pdfService
              .insertIntoFavoritePdfList(widget.paths, SqlModel.tableFavorite)
              .whenComplete(() => Navigator.pop(context));
        }
      },
    );
  }
}
