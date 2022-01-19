import 'package:flutter/material.dart';
import 'package:pdfviewer/MainPages/homepage/addremove_widget.dart';
import 'package:pdfviewer/common%20mehtod/addIntoRecentMethod.dart';
import 'package:pdfviewer/common%20mehtod/navigate_to_viewpdf.dart';
import 'package:pdfviewer/model/pdf_list_model.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/widget/CommonWidget/delete_file_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/share_file_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/rename_files_widget.dart';
import 'package:pdfviewer/widget/CommonWidget/title_of_bottomsheetpdf.dart';
import 'package:pdfviewer/widget/CommonWidget/favorite_icon.dart';
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
            String filePath = pdfservice.files[index].pdfpath.toString();
            String fileDate = pdfservice.files[index].date.toString();
            String fileSize = pdfservice.files[index].size.toString();
            String fileTitle = pdfservice.files[index].pdfname.toString();

            Iterable<PdfListModel> isfav = pdfservice.favoritePdfList
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
                    FavoriteStarIcon(isfav: isfav),
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
                                  TitleOfPdf(titlePath: fileTitle),
                                  ShareFiles(
                                    fileName: filePath,
                                  ),
                                  AddRemoveWidget(paths: filePath),
                                  RenameFileWidget(
                                      fileName: filePath,
                                      callback: (String newFileName) {
                                        pdfservice.changeFileNameOnly(
                                            context, newFileName, index);
                                      }),
                                  DeleteFileWidget(
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
                  AddIntoRecentsMethod().addIntoRecents(filePath, context);
                  NavigateToViewPdf().navigateToViewPdf(
                      pdfservice.files[index], pdfservice, context, index);
                },
              ),
            );
          },
        );
      },
    );
  }
}
