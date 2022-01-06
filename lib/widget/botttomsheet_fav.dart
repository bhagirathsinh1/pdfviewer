import 'package:flutter/material.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_model.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_serrvice.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/dialogue/delete_dialouge.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/delete_file.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class BottomsheetFavoritePage extends StatefulWidget {
  final int index;
  final String fileName;
  final snapshot;
  BottomsheetFavoritePage(
      {Key? key,
      required this.index,
      required this.fileName,
      required this.snapshot})
      : super(key: key);

  @override
  _BottomsheetFavoritePageState createState() =>
      _BottomsheetFavoritePageState();
}

class _BottomsheetFavoritePageState extends State<BottomsheetFavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 250,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.yellow[100],
                border: Border.all(
                  color: Colors.grey,
                  width: 5,
                )),
            child: ListTile(
              title: Text(
                widget.snapshot.data![widget.index].pdf
                    .toString()
                    .split('/')
                    .last,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              leading: Icon(
                Icons.picture_as_pdf,
                color: Colors.red,
              ),
              onTap: () {},
            ),
          ),
          ListTile(
            title: Text(
              "Share",
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            leading: Icon(
              Icons.share,
              color: Colors.black.withOpacity(0.5),
            ),
            onTap: () {
              List<String> paths = [
                widget.snapshot.data![widget.index].pdf.toString()
              ];
              Share.shareFiles(paths);
            },
          ),
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
                  .removeFromFavoriteCalled(
                      widget.snapshot.data![widget.index].pdf.toString(),
                      SqlModel.tableFavorite);
            },
          ),
          DeleteFileWidget(
            onTap: () {
              var fileName = widget.snapshot.data![widget.index].pdf.toString();

              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return new DeleteFileDialouge(
                      index: widget.index,
                      fileName: fileName,
                    );
                  });
            },
            index: widget.index,
            fileName: widget.fileName,
          ),
        ],
      ),
    );
  }
}
