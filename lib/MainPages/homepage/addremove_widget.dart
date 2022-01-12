import 'package:flutter/material.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
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
    var isfav = Provider.of<PdfFileService>(context, listen: false)
        .favoritePdfList
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
          Provider.of<PdfFileService>(context, listen: false)
              .removeFromFavoritePdfList(
                  widget.paths.toString(), SqlModel.tableFavorite)
              .whenComplete(() => Navigator.pop(context));
        } else {
          Provider.of<PdfFileService>(context, listen: false)
              .insertIntoFavoritePdfList(widget.paths, SqlModel.tableFavorite)
              .whenComplete(() => Navigator.pop(context));
        }
      },
    );
  }
}