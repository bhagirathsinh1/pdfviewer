import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:intl/intl.dart';
import 'package:path_provider_extention/path_provider_extention.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_model.dart';
import 'package:pdfviewer/SQLService/recent_pdf_model.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/model/pdf_list_model.dart';
import 'package:pdfviewer/service/singing_character_enum.dart';

class PdfFileService with ChangeNotifier {
  // List starPDF = [];
  bool isDeleted = false;
  bool isNameSort = false;
  bool isDateSort = false;
  bool isSizeAccending = false;
  bool isSizeDeccending = false;
  bool isReverseSized = false;
  SingingCharacter? _character;

  // List<RecentListPdfModel> recentPdfList = [];
  List<PdfListModel> items = [];

  List<PdfListModel> favoritePdfList = [];
  List<PdfListModel> files = [];
  List<PdfListModel> recentPdfList = [];

  Future getRecentPdfList() async {
    final dbClient = await SqlModel().db;

    List<Map<String, Object?>> futurePDFList = await dbClient.rawQuery(
      "Select *from ${SqlModel.tableRecent}  order by auto_id DESC",
    );

    var tempValue = recentListPdfModelFromJson(jsonEncode(futurePDFList));
    print(tempValue);
    recentPdfList = [];

    for (var file in tempValue) {
      File filePath = File(file.recentpdf.toString());
      var pdfname = filePath.path.split('/').last;

      var lastModDate1 = filePath.lastModifiedSync();
      var formattedDate1 = DateFormat('EEE, M/d/y').format(lastModDate1);

      var finalFileSize = filePath.lengthSync();
      var sizeInKb = (finalFileSize / (1024)).toStringAsFixed(2);
      var pdfmodel = PdfListModel(
          referenceFile: filePath,
          pdfname: pdfname,
          date: formattedDate1,
          size: sizeInKb,
          pdfpath: filePath.path,
          isFav: favoritePdfList
              .where((element) => element.pdfpath == filePath)
              .isNotEmpty);

      recentPdfList.add(pdfmodel);
    }

    notifyListeners();
  }

  Future getFavoritePdfList() async {
    final dbClient = await SqlModel().db;
    List<Map<String, Object?>> futurePDFList = await dbClient.rawQuery(
        "Select *from ${SqlModel.tableFavorite}   order by auto_id DESC");

    var tempValue = favouriteListPdfModelFromJson(jsonEncode(futurePDFList));
    print(tempValue);
    favoritePdfList = [];
    for (var file in tempValue) {
      File filePath = File(file.pdf.toString());
      var pdfname = filePath.path.split('/').last;

      var lastModDate1 = filePath.lastModifiedSync();
      var formattedDate1 = DateFormat('EEE, M/d/y').format(lastModDate1);

      var finalFileSize = filePath.lengthSync();
      var sizeInKb = (finalFileSize / (1024)).toStringAsFixed(2);
      var pdfmodel = PdfListModel(
        referenceFile: filePath,
        pdfname: pdfname,
        date: formattedDate1,
        size: sizeInKb,
        pdfpath: filePath.path,
        isFav: favoritePdfList
            .where((element) => element.pdfpath == filePath)
            .isNotEmpty,
      );

      favoritePdfList.add(pdfmodel);
    }
    notifyListeners();
  }

  Future<bool> removeFromRecentPdfList(arriveDataRecent, String table) async {
    final dbClientremoveFromRecentPdfList = await SqlModel().db;
    try {
      var resultremoveFromRecentPdfList =
          await dbClientremoveFromRecentPdfList.rawQuery(
        'DELETE FROM $table WHERE recentpdf = ?',
        [arriveDataRecent],
      );
      print("deleted in recent index $resultremoveFromRecentPdfList");
      getRecentPdfList();
      notifyListeners();

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> removeFromFavoritePdfList(arrivdata, String table) async {
    print("-----------remove from favorite called------------");
    final dbClientRemoveFromFavorite = await SqlModel().db;
    try {
      var resultRemoveFromFav = await dbClientRemoveFromFavorite.rawQuery(
        'DELETE FROM $table WHERE pdf = ?',
        [arrivdata],
      ).whenComplete(() {
        getFavoritePdfList();
        notifyListeners();
      });
      print(
          "-----------------------------deleted index $resultRemoveFromFav--------------------------");
      // getFavoritePdfList();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> clearRecentPdfList(String table) async {
    final dbClientDelete = await SqlModel().db;
    try {
      var resultDelete = await dbClientDelete.rawQuery(
          """DELETE FROM $table""").whenComplete(() => notifyListeners());
      print("deleted result $resultDelete");
      getRecentPdfList();
      notifyListeners();

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> clearFavoritePdfList(String table) async {
    final dbClientDelete = await SqlModel().db;
    try {
      var resultDelete = await dbClientDelete.rawQuery(
          """DELETE FROM $table""").whenComplete(() => notifyListeners());
      print("deleted result $resultDelete");
      getFavoritePdfList();
      // getFavoritePdfList();
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> insertIntoFavoritePdfList(String pdfPath, table) async {
    final dbClient = await SqlModel().db;

    var isExist = await _checkrecordExists(pdfPath.toString());

    if (!isExist) {
      try {
        Map<String, Object> data = {
          'pdf': (pdfPath),
        };
        await dbClient.insert(table, data);
        getFavoritePdfList();
        getRecentPdfList();
        return true;
      } catch (e) {
        // throw "asd";
        print(e);
        return false;
      }
    } else {
      throw "Already added in favorite";
    }
  }

  Future<bool> _checkrecordExists(String data) async {
    final dbClient = await SqlModel().db;

    try {
      var result = await dbClient.rawQuery(
          """select *from ${SqlModel.tableFavorite} where pdf= '$data'""");

      print("result $result");

      if (result.isNotEmpty) {
        return true;
      } else {
        return false;
      }
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
      getStorageFilleMethod();
      getFavoritePdfList();
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

  getStorageFilleMethod() async {
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
        isFav: favoritePdfList
            .where((element) => element.pdfpath == file.path)
            .isNotEmpty,
      );
      files.add(pdfmodel);
    }

    notifyListeners();
    print(files);
    //update the UI
  }

  changeFileNameOnly(
      BuildContext context, String newFileName, int index) async {
    print("------------->arrived new name----$newFileName--------");
    var temp1 = files[index].referenceFile!.path;

    var lastSeparator = temp1.lastIndexOf(Platform.pathSeparator);
    var newPath = temp1.substring(0, lastSeparator + 1) + newFileName + ".pdf";

    print("------------->arrived new name----$newPath--------");

    var filename = await files[index].referenceFile!.rename(newPath);

    print("-------------v.path data---------------- ${filename.path}");

    files[index].referenceFile = filename;
    files[index].pdfpath = filename.path;

    files[index].pdfname = filename.path.split('/').last;

    getStorageFilleMethod();
    notifyListeners();
    // Navigator.pop(context);
    // ScaffoldMessenger.of(context).clearSnackBars();
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text("Renamed to  ${newFileName}"),
    //   ),
    // );
  }
}
