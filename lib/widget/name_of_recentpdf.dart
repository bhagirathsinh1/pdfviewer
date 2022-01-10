import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdfviewer/MainPages/home_page.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/bottomsheet_recent.dart';
import 'package:pdfviewer/widget/page_view.dart';
import 'package:provider/provider.dart';

class NameOfRecentPdf extends StatelessWidget {
  const NameOfRecentPdf({Key? key, required this.snapshot}) : super(key: key);
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
          snapshot.data![index].recentpdf.toString(),
        );
        var finalFileSize = filesize.lengthSync();
        var sizeInKb = (finalFileSize / (1024)).toStringAsFixed(2);

        File datefile = new File(
          snapshot.data![index].recentpdf.toString(),
        );

        var lastModDate1 = datefile.lastModifiedSync();
        var formattedDate = DateFormat('EEE, M/d/y').format(lastModDate1);
        print("dataaay is $snapshot.data![index].recentpdf");

        return Card(
          child: ListTile(
            title: Text(
                snapshot.data![index].recentpdf!.split('/').last.toString()),
            subtitle: sizeInKb.length < 7
                ? Text("${formattedDate.toString()}\n${sizeInKb} Kb")
                : Text(
                    "${formattedDate.toString()}\n${(finalFileSize / (1024.00 * 1024)).toStringAsFixed(2)} Mb"),
            leading: Icon(
              Icons.picture_as_pdf,
              color: Colors.red,
            ),
            trailing: Wrap(children: [
              Consumer<PdfFileService>(builder: (context, counter, child) {
                return Icon(
                  Icons.star,
                  color: Provider.of<PdfFileService>(context, listen: false)
                          .starPDF
                          .toString()
                          .contains(snapshot.data![index].recentpdf.toString())
                      ? Colors.blue
                      : Colors.white,
                );
              }),
              IconButton(
                onPressed: () async {
                  var fileName = snapshot.data![index].recentpdf.toString();

                  await showModalBottomSheet<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return BotomsheetRecentPage(
                          fileName: fileName, index: index, snapshot: snapshot);
                    },
                  );
                },
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.redAccent,
                ),
              ),
            ]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ViewPDF(
                      pathPDF: snapshot.data![index].recentpdf.toString(),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
