import 'package:flutter/material.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_model.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/favorite_clear_widget.dart';
import 'package:pdfviewer/widget/name_of_favoritepdf.dart';
import 'package:provider/provider.dart';

class Favouritepage extends StatefulWidget {
  const Favouritepage({Key? key}) : super(key: key);

  @override
  _FavouritepageState createState() => _FavouritepageState();
}

class _FavouritepageState extends State<Favouritepage> {
  @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "PDF Reader",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return FavoriteClear();
                },
              );
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Consumer<PdfFileService>(
        builder: (context, counter, child) {
          return FutureBuilder(
            future: counter.getFavoritePdfList(),
            builder: (BuildContext context,
                AsyncSnapshot<List<FavouriteListPdfModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  print("------------------response positive-------------");

                  if (snapshot.data!.isEmpty) {
                    return Center(child: Text("Data is empty !"));
                  } else {
                    return NameOfFavoritePDF(snapshot: snapshot);
                  }
                }
                if (snapshot.hasError) {
                  return Text(snapshot.hasError.toString());
                } else {
                  return Text("Somehting went wrong");
                }
              } else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
