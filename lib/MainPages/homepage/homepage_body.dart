import 'package:flutter/material.dart';
import 'package:pdfviewer/MainPages/homepage/addremove_widget.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_serrvice.dart';
import 'package:pdfviewer/SQLService/recent_pdf_service.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/MainPages/homepage/home_page.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/CommonWidget/delete_file_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/share_file_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/page_view.dart';
import 'package:pdfviewer/widget/CommonWidget/rename_files_widget.dart';
import 'package:provider/provider.dart';

class HomepageBody extends StatefulWidget {
  HomepageBody({Key? key}) : super(key: key);

  @override
  _HomepageBodyState createState() => _HomepageBodyState();
}

class _HomepageBodyState extends State<HomepageBody> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PdfFileService>(
      builder: (context, pdfservice, child) {
        return ListView.builder(
          itemCount: pdfservice.files.length,
          itemBuilder: (BuildContext ctxt, index) {
            var filePath = pdfservice.files[index].pdfpath.toString();
            var fileDate = pdfservice.files[index].date.toString();
            var fileSize = pdfservice.files[index].size.toString();
            var fileTitle = pdfservice.files[index].pdfname.toString();

            var isfav = pdfservice.favoritePdfList
                .where((element) => element.pdfpath == filePath);
            return Card(
              child: ListTile(
                title: Text(fileTitle),
                subtitle: fileSize.length < 7
                    ? Text("${fileDate}\n${fileSize} Kb")
                    : Text(
                        "${fileDate}\n${(double.parse(fileSize) / 1024).toStringAsFixed(2)} Mb"),
                leading: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                ),
                trailing: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {},
                      constraints: BoxConstraints(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      icon: Icon(
                        Icons.star,
                        color: !isfav.isEmpty ? Colors.blue : Colors.white,
                      ),
                    ),
                    IconButton(
                      constraints: BoxConstraints(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      onPressed: () {
                        print(filePath);
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              color: Colors.white,
                              height: 350,
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
                                          pdfservice.files[index].pdfname
                                              .toString(),
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          )),
                                      leading: Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.red,
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                  ShareFiles(
                                    fileName: filePath,
                                    index: index,
                                  ),
                                  AddRemoveWidget(paths: filePath),
                                  RenameFileWidget(
                                    index: index,
                                    fileName: filePath,
                                  ),
                                  DeleteFileWidget(
                                    index: index,
                                    fileName: filePath,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  // recent_index = index;

                  Map<String, Object> data = {
                    'recentpdf': (filePath),
                  };

                  if (!data.isEmpty) {
                    try {
                      await RecentSQLPDFService()
                          .insertRecentPDF(data, SqlModel.tableRecent);

                      Provider.of<PdfFileService>(context, listen: false)
                          .getRecentPdfList();
                    } catch (e) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.toString(),
                          ),
                        ),
                      );
                    }
                    print("pdfname is--------------> $data");
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ViewPDF(
                          pathPDF: filePath,
                        );
                        //open ViewPDFHomeScreen page on click
                      },
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
