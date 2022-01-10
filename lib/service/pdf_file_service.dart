import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:intl/intl.dart';
import 'package:path_provider_extention/path_provider_extention.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_model.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_serrvice.dart';
import 'package:pdfviewer/SQLService/recent_pdf_model.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/MainPages/home_page.dart';
import 'package:pdfviewer/model/pdf_list_model.dart';
import 'package:pdfviewer/service/singing_character_enum.dart';
import 'package:provider/provider.dart';

class PdfFileService with ChangeNotifier {
  bool isNameSort = false;
  bool isDateSort = false;
  bool isSizeAccending = false;
  bool isSizeDeccending = false;
  bool isReverseSized = false;
  SingingCharacter? _character;

  // List<File> files = [];
  List<PdfListModel> files = [];

  starPDF() async {
    Homepage.starPDF.clear();

    final dbClient = await SqlModel().db;

    List<Map<String, Object?>> tempPDF =
        await dbClient.rawQuery("Select *from ${SqlModel.tableFavorite}");
    Homepage.starPDF.addAll(tempPDF);
  }

  Future<bool> clearRecentPdfData(String table) async {
    final dbClientDelete = await SqlModel().db;
    try {
      var resultDelete =
          await dbClientDelete.rawQuery("""DELETE FROM $table""");
      print("deleted result $resultDelete");
      notifyListeners();

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> removeFromRecent(arriveDataRecent, String table) async {
    final dbClientRemoveFromRecent = await SqlModel().db;
    try {
      var resultRemoveFromRecent = await dbClientRemoveFromRecent.rawQuery(
        'DELETE FROM $table WHERE recentpdf = ?',
        [arriveDataRecent],
      );
      print("deleted in recent index $resultRemoveFromRecent");
      notifyListeners();

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<RecentListPdfModel>> getallPDFRecent() async {
    final dbClient = await SqlModel().db;
    List<RecentListPdfModel> list = [];

    List<Map<String, Object?>> futurePDFList = await dbClient.rawQuery(
      "Select *from ${SqlModel.tableRecent}",
    );

    futurePDFList.forEach(
      (element) {
        list.add(RecentListPdfModel.fromJson(element));
      },
    );
    return list;
  }

  addFavorite(BuildContext context, snapshot, int index) async {
    Map<String, Object> data = {
      'pdf': (snapshot.data![index].recentpdf.toString()),
    };
    if (!data.isEmpty) {
      try {
        await SQLPDFService()
            .insertPDF(data, SqlModel.tableFavorite)
            .whenComplete(() {
          starPDF();
          getallPDFRecent();
          notifyListeners();
        });
        ;
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
      print("pdfname is--------------> $data");
    }
    Navigator.pop(context);
  }

  removeFromFavorite(BuildContext context, snapshot, int index) async {
    await PdfFileService()
        .removeFromFavoriteCalled(
            snapshot.data![index].recentpdf.toString(), SqlModel.tableFavorite)
        .whenComplete(() {
      starPDF();

      // getallPDFRecent();
      notifyListeners();
    });
    Navigator.pop(context);
  }

  Future<bool> removeFromFavoriteCalled(arrivdata, String table) async {
    print("-----------remove from favorite called------------");
    final dbClientRemoveFromFavorite = await SqlModel().db;
    try {
      var resultRemoveFromFav = await dbClientRemoveFromFavorite.rawQuery(
        'DELETE FROM $table WHERE pdf = ?',
        [arrivdata],
      );
      print(
          "-----------------------------deleted index $resultRemoveFromFav--------------------------");
      // getFavoritePdf();
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<FavouriteListPdfModel>> getFavoritePdf() async {
    final dbClient = await SqlModel().db;
    List<Map<String, Object?>> futurePDFList =
        await dbClient.rawQuery("Select *from ${SqlModel.tableFavorite}");
    List<FavouriteListPdfModel> list = [];
    futurePDFList.forEach(
      (element) {
        list.add(FavouriteListPdfModel.fromJson(element));
      },
    );
    return list;
  }

  Future<bool> clearData(String table) async {
    final dbClientDelete = await SqlModel().db;
    try {
      var resultDelete =
          await dbClientDelete.rawQuery("""DELETE FROM $table""");
      print("deleted result $resultDelete");
      // getFavoritePdf();
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
      print("-------------------file name ${file}---------------------------");
      // removeFromFavorite(file, SqlModel.tableFavorite);
      getFiles();
      getFavoritePdf();
      notifyListeners();
      print(
          "-----------table favorite ${SqlModel.tableFavorite}--------------");
    } catch (e) {
      print(e);
    }
  }

  accendingSort() {
    files.sort(
      (b, a) {
        return b.referenceFile!
            .lengthSync()
            .compareTo(a.referenceFile!.lengthSync());
      },
    );
    notifyListeners();
    return true;
  }

  deccendingSort() {
    files.sort(
      (a, b) {
        return b.referenceFile!
            .lengthSync()
            .compareTo(a.referenceFile!.lengthSync());
      },
    );
    notifyListeners();
    return true;
  }

  nameSort() {
    files.sort(
      (a, b) {
        return a.pdfname!.compareTo(b.pdfname!);
      },
    );
    notifyListeners();
    return true;
  }

  dateSort() {
    files.sort(
      (b, a) {
        return a.referenceFile!
            .lastModifiedSync()
            .compareTo(b.referenceFile!.lastModifiedSync());
      },
    );
    notifyListeners();
    return true;
  }

  Future<void> sortingPdfMethod(
      isReverseSized,
      isSizeAccending,
      isSizeDeccending,
      isNameSort,
      isDateSort,
      BuildContext context,
      value) async {
    if (isSizeAccending == true) {
      try {
        Future.delayed(
          const Duration(milliseconds: 200),
          () async {
            // Provider.of<PdfFileService>(context, listen: false).files.sort(
            //   (b, a) {
            //     return b.lengthSync().compareTo(a.lengthSync());
            //   },
            // );
            _character = value;
            isReverseSized = true;
            isSizeAccending = true;
            isSizeDeccending = false;
            isNameSort = false;
            isDateSort = false;
          },
        )
            .whenComplete(() => notifyListeners())
            .whenComplete(() => Navigator.pop(context));
      } catch (e) {
        print('-------------------> error ---> $e');
      }
    }
  }

  void getFiles() async {
    //asyn function to get list of files
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0]
        .rootDir; //storageInfo[1] for SD card, geting the root directory
    var fm = FileManager(root: Directory(root)); //
    var temmpfiles = await fm.filesTree(
        excludedPaths: ["/storage/emulated/0/Android"],
        extensions: ["pdf"] //optional, to filter files, list only pdf files
        );

    files = [];
    for (var file in temmpfiles) {
      var pdfname = file.path.split('/').last;

      var lastModDate1 = file.lastModifiedSync();
      var formattedDate = DateFormat('EEE, M/d/y').format(lastModDate1);

      var finalFileSize = file.lengthSync();
      var sizeInKb = (finalFileSize / (1024)).toStringAsFixed(2);

      var pdfmodel = PdfListModel(
        referenceFile: file,
        pdfname: pdfname,
        date: formattedDate,
        size: sizeInKb,
        pdfpath: file.path,
      );
      files.add(pdfmodel);
    }

    notifyListeners();
    print(files);
    //update the UI
  }
}
