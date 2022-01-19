import 'package:flutter/material.dart';
import 'package:pdfviewer/MainPages/favoritepage/no_pdf_found.dart';
import 'package:pdfviewer/common%20mehtod/navigate_to_viewpdf.dart';
import 'package:pdfviewer/model/pdf_list_model.dart';

import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/MainPages/recentpage/bottomsheet_recentpage.dart';
import 'package:pdfviewer/MainPages/recentpage/recentlist_clear_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/favorite_icon.dart';
import 'package:provider/provider.dart';

class Recentpage extends StatefulWidget {
  const Recentpage({Key? key}) : super(key: key);

  @override
  _RecentpageState createState() => _RecentpageState();
}

class _RecentpageState extends State<Recentpage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfFileService>(builder: (context, pdfservice, child) {
      return Scaffold(
          backgroundColor: Colors.white,
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
                      return RecentClear();
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
          body: pdfservice.recentPdfList.isEmpty
              ? Center(child: NoPdfFound(listName: 'Recent'))
              : ListView.builder(
                  // reverse: true,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: pdfservice.recentPdfList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String filePath =
                        pdfservice.recentPdfList[index].pdfpath.toString();
                    String fileDate =
                        pdfservice.recentPdfList[index].date.toString();
                    String fileSize =
                        pdfservice.recentPdfList[index].size.toString();
                    String fileTitle =
                        pdfservice.recentPdfList[index].pdfname.toString();
                    Iterable<PdfListModel> isfav = pdfservice.favoritePdfList
                        .where((element) => element.pdfpath == filePath);
                    return Card(
                        child: ListTile(
                            title: Text(fileTitle),
                            subtitle: fileSize.length < 7
                                ? Text("${fileDate}\n${fileSize} Kb")
                                : Text(
                                    "${fileDate}\n${(double.parse(fileSize) / 1024).toStringAsFixed(2)} Mb",
                                  ),
                            leading: Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                            ),
                            trailing: Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  FavoriteStarIcon(isfav: isfav),
                                  IconButton(
                                    constraints: BoxConstraints(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 10),
                                    onPressed: () async {
                                      await showModalBottomSheet<bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return BotomsheetRecentPage(
                                            fileName: filePath.toString(),
                                          );
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
                              NavigateToViewPdf().navigateToViewPdf(
                                  pdfservice.recentPdfList[index],
                                  pdfservice,
                                  context,
                                  index);
                            }));
                  }));
    });
  }
}
