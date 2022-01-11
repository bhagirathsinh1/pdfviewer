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

class ListAllPdf extends StatefulWidget {
  ListAllPdf({Key? key}) : super(key: key);

  @override
  _ListAllPdfState createState() => _ListAllPdfState();
}

class _ListAllPdfState extends State<ListAllPdf> {
  var finalFileSize;
  String? formattedDate;

  // void initState() {
  //   super.initState();

  //   Provider.of<PdfFileService>(context, listen: false)
  //       .starPDFMethod(); // setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfFileService>(
      builder: (context, pdfservice, child) {
        return ListView.builder(
          // reverse: isReverse Sized,
          //if file/folder list is grabbed, then show here
          itemCount: pdfservice.files.length,
          itemBuilder: (BuildContext ctxt, index) {
            return Card(
              child: ListTile(
                title: Text(pdfservice.files[index].pdfname.toString()),
                subtitle: pdfservice.files[index].size!.length < 7
                    ? Text(
                        "${pdfservice.files[index].date.toString()}\n${pdfservice.files[index].size} Kb")
                    : Text(
                        "${pdfservice.files[index].date.toString()}\n${(double.parse(pdfservice.files[index].size.toString()) / 1024).toStringAsFixed(2)} Mb"),
                leading: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                ),
                trailing: Wrap(
                  children: [
                    Icon(
                      Icons.star,
                      color: pdfservice.starPDF.toString().contains(
                              pdfservice.files[index].pdfpath.toString())
                          ? Colors.blue
                          : Colors.white,
                    ),
                    IconButton(
                      onPressed: () {
                        var fileName =
                            pdfservice.files[index].pdfpath.toString();
                        print(fileName);
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            var paths =
                                pdfservice.files[index].pdfpath.toString();
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
                                      fileName: fileName,
                                      index: index,
                                      paths: paths),
                                  AddRemoveWidget(
                                      title: pdfservice.starPDF
                                          .toString()
                                          .contains(paths),
                                      paths: paths),
                                  RenameFileWidget(
                                    index: index,
                                    fileName: fileName,
                                  ),
                                  DeleteFileWidget(
                                    index: index,
                                    fileName: fileName,
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
                    'recentpdf': (pdfservice.files[index].pdfpath.toString()),
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
                          pathPDF: pdfservice.files[index].pdfpath.toString(),
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

  // removeFromFavorite() async {
  //   Provider.of<PdfFileService>(context, listen: false)
  //       .removeFromFavoritePdfList(
  //           Provider.of<PdfFileService>(context, listen: false)
  //               .files[Homepage.favorite_index]
  //               .pdfpath
  //               .toString(),
  //           SqlModel.tableFavorite);

  //   Navigator.pop(context);
  // }

  // addFavorite() async {
  //   Map<String, Object> data = {
  //     'pdf': (Provider.of<PdfFileService>(context, listen: false)
  //         .files[Homepage.favorite_index]
  //         .pdfpath
  //         .toString()),
  //   };
  //   if (!data.isEmpty) {
  //     try {
  //       await SQLPDFService().insertIntoFavoritePdfList(data, SqlModel.tableFavorite);
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).clearSnackBars();
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text(e.toString())));
  //     }
  //     // print("pdfname is--------------> $data");
  //   }
  //   Navigator.pop(context);
  //   // initState();
  // }
}
