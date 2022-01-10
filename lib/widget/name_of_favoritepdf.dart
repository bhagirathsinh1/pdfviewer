import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdfviewer/widget/botttomsheet_fav.dart';
import 'package:pdfviewer/widget/page_view.dart';

class NameOfFavoritePDF extends StatelessWidget {
  const NameOfFavoritePDF({Key? key, required this.snapshot}) : super(key: key);
  final snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // reverse: true,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: snapshot.data!.length,
      itemBuilder: (BuildContext context, int index) {
        File filesize = File(
          snapshot.data![index].pdf.toString(),
        );
        var finalFileSize = filesize.lengthSync();
        var sizeInKb = (finalFileSize / (1024)).toStringAsFixed(2);

        File datefile = new File(
          snapshot.data![index].pdf.toString(),
        );

        var lastModDate1 = datefile.lastModifiedSync();
        var formattedDate = DateFormat('EEE, M/d/y').format(lastModDate1);
        print("dataaay is $snapshot.data![index].pdf");
        return Card(
          child: ListTile(
            title: Text(snapshot.data![index].pdf!.split('/').last.toString()),
            subtitle: sizeInKb.length < 7
                ? Text("${formattedDate.toString()}\n${sizeInKb} Kb")
                : Text(
                    "${formattedDate.toString()}\n${(finalFileSize / (1024.00 * 1024)).toStringAsFixed(2)} Mb"),
            leading: Icon(
              Icons.picture_as_pdf,
              color: Colors.red,
            ),
            trailing: IconButton(
              onPressed: () {
                // newindex = index;
                var fileName = snapshot.data![index].pdf.toString();

                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return BottomsheetFavoritePage(
                        fileName: fileName, index: index, snapshot: snapshot);
                  },
                );
              },
              icon: Icon(
                Icons.more_vert,
                color: Colors.redAccent,
              ),
            ),
            onTap: () {
              Future.delayed(
                Duration.zero,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ViewPDF(
                          pathPDF: snapshot.data![index].pdf.toString(),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
