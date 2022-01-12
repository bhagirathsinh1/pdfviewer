// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:pdfviewer/SQLService/sqlService.dart';
// import 'package:pdfviewer/service/pdf_file_service.dart';
// import 'package:provider/provider.dart';

// class BottomsheetViewPdf extends StatefulWidget {
//   const BottomsheetViewPdf({
//     Key? key,
//     required this.isContinuePage,
//     required this.sizeInKb,
//     required this.formattedDate,
//     required this.pathPDF,
//     required this.finalFileSize,
//   }) : super(key: key);
//   final bool isContinuePage;
//   final sizeInKb;
//   final formattedDate;
//   final pathPDF;
//   final finalFileSize;
//   @override
//   State<BottomsheetViewPdf> createState() => _BottomsheetViewPdfState();
// }

// class _BottomsheetViewPdfState extends State<BottomsheetViewPdf> {

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<PdfFileService>(builder: (context, counter, child) {
//       return SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Container(
//           color: Colors.white,
//           height: 560,
//           child: Column(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                     color: Colors.yellow[100],
//                     border: Border.all(
//                       color: Colors.grey,
//                       width: 5,
//                     )),
//                 child: ListTile(
//                   title: Text(
//                     File(widget.pathPDF).toString().split('/').last,
//                     style: TextStyle(
//                       color: Colors.black.withOpacity(0.8),
//                     ),
//                   ),
//                   subtitle: widget.sizeInKb.length < 7
//                       ? Text(
//                           "${widget.formattedDate.toString()}\n${widget.sizeInKb} Kb")
//                       : Text(
//                           "${widget.formattedDate.toString()}\n${(widget.finalFileSize / (1024.00 * 1024)).toStringAsFixed(2)} Mb"),
//                   leading: Icon(
//                     Icons.picture_as_pdf,
//                     color: Colors.red,
//                   ),
//                   onTap: () {},
//                 ),
//               ),
//               ListTile(
//                 title: Text(
//                   "Continuous page",
//                   style: TextStyle(
//                     color: widget.isContinuePage
//                         ? Colors.black.withOpacity(0.8)
//                         : Colors.blue.withOpacity(0.8),
//                   ),
//                 ),
//                 leading: Icon(
//                   Icons.print,
//                   color: widget.isContinuePage
//                       ? Colors.black.withOpacity(0.5)
//                       : Colors.blue.withOpacity(0.8),
//                 ),
//                 onTap: () {
//                   setState(() {
//                     ViewPDF().isContinuePage = false;
//                   });
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: Text(
//                   "Page by page",
//                   style: TextStyle(
//                     color: widget.isContinuePage
//                         ? Colors.blue.withOpacity(0.8)
//                         : Colors.black.withOpacity(0.8),
//                   ),
//                 ),
//                 leading: Icon(
//                   Icons.call_to_action_rounded,
//                   color: widget.isContinuePage
//                       ? Colors.blue.withOpacity(0.8)
//                       : Colors.black.withOpacity(0.5),
//                 ),
//                 onTap: () {
//                   setState(() {
//                     widget.isContinuePage = true;
//                   });
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: Text(
//                   "Night Mode",
//                   style: TextStyle(
//                     color: Colors.black.withOpacity(0.8),
//                   ),
//                 ),
//                 leading: Icon(
//                   Icons.nights_stay,
//                   color: Colors.black.withOpacity(0.5),
//                 ),
//                 onTap: () {},
//               ),
//               ListTile(
//                 title: Text(
//                   "Go to page",
//                   style: TextStyle(
//                     color: Colors.black.withOpacity(0.8),
//                   ),
//                 ),
//                 leading: Icon(
//                   Icons.screen_search_desktop_rounded,
//                   color: Colors.black.withOpacity(0.5),
//                 ),
//                 onTap: () {
//                   showGotoAlert(context);

//                   // Navigator.pop(context);
//                 },
//               ),
//               Divider(
//                 height: 5,
//                 color: Colors.grey,
//               ),
//               ListTile(
//                 title: Text(
//                   "Add to favorite",
//                   style: TextStyle(
//                     color: Colors.black.withOpacity(0.8),
//                   ),
//                 ),
//                 leading: Icon(
//                   Icons.star_border,
//                   color: Colors.black.withOpacity(0.5),
//                 ),
//                 onTap: () async {
//                   try {
//                     await PdfFileService().insertIntoFavoritePdfList(
//                         File(widget.pathPDF).path.toString(),
//                         SqlModel.tableFavorite);
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).clearSnackBars();
//                     ScaffoldMessenger.of(context)
//                         .showSnackBar(SnackBar(content: Text(e.toString())));
//                   }
//                   // print("pdfname is--------------> $data");

//                   Navigator.pop(context);
//                   initState();
//                 },
//               ),
//               ListTile(
//                 title: Text(
//                   "Rename",
//                   style: TextStyle(
//                     color: Colors.black.withOpacity(0.8),
//                   ),
//                 ),
//                 leading: Icon(
//                   Icons.drive_file_rename_outline_outlined,
//                   color: Colors.black.withOpacity(0.5),
//                 ),
//                 onTap: () {},
//               ),
//               ListTile(
//                 title: Text(
//                   "Print",
//                   style: TextStyle(
//                     color: Colors.black.withOpacity(0.8),
//                   ),
//                 ),
//                 leading: Icon(
//                   Icons.local_print_shop_rounded,
//                   color: Colors.black.withOpacity(0.5),
//                 ),
//                 onTap: () {},
//               ),
//               ListTile(
//                 title: Text(
//                   "Delete",
//                   style: TextStyle(
//                     color: Colors.black.withOpacity(0.8),
//                   ),
//                 ),
//                 leading: Icon(
//                   Icons.delete_rounded,
//                   color: Colors.black.withOpacity(0.5),
//                 ),
//                 onTap: () {
//                   // DeleteFileWidget(
//                   //   index: widget.index,
//                   //   fileName: File(widget.pathPDF).toString(),
//                   // );
//                   // deleteDialougeFavoriteScreen(
//                   //   context,
//                   //   File(widget.pathPDF).toString(),
//                   // );
//                   print('--------------delete clicked---------');
//                 },
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
