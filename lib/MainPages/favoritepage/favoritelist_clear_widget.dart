import 'package:flutter/material.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_serrvice.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:provider/provider.dart';

class FavoriteClear extends StatefulWidget {
  FavoriteClear({Key? key}) : super(key: key);

  @override
  _FavoriteClearState createState() => _FavoriteClearState();
}

class _FavoriteClearState extends State<FavoriteClear> with ChangeNotifier {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 70,
      child: Column(
        children: [
          ListTile(
            title: Text(
              "Clear Favorites",
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
                  .clearFavoritePdfList(SqlModel.tableFavorite);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Favorite list cleared !!"),
              ));
            },
          ),
        ],
      ),
    );
  }
}
