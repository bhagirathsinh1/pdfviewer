import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:intl/intl.dart';
import 'package:path_provider_extention/path_provider_extention.dart';
import 'package:pdfviewer/SQLService/favorite_pdf_model.dart';
import 'package:pdfviewer/SQLService/recent_pdf_model.dart';
import 'package:pdfviewer/SQLService/recent_pdf_service.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/model/pdf_list_model.dart';
import 'package:pdfviewer/service/sorting_enum.dart';

class PdfFileService with ChangeNotifier {
  // List starPDF = [];
  bool isDeleted = false;
  bool isNameSort = false;
  bool isDateSort = false;
  bool isSizeAccending = false;
  bool isSizeDeccending = false;
  bool isReverseSized = false;
  Sortingenum? _character;

  // List<RecentListPdfModel> recentPdfList = [];

  List<PdfListModel> favoritePdfList = [];
  List<PdfListModel> files = [];
  List<PdfListModel> recentPdfList = [];
  List<PdfListModel> items = [];

  Future getRecentPdfList() async {
    final dbClient = await SqlModel().db;

    List<Map<String, Object?>> futurePDFList = await dbClient.rawQuery(
      "Select *from ${SqlModel.tableRecent}  order by auto_id DESC",
    );

    List<RecentListPdfModel> tempValue =
        recentListPdfModelFromJson(jsonEncode(futurePDFList));
    print(tempValue);
    recentPdfList = [];

    for (RecentListPdfModel file in tempValue) {
      File filePath = File(file.recentpdf.toString());
      String pdfname = filePath.path.split('/').last;

      DateTime lastModDate1 = filePath.lastModifiedSync();
      String formattedDate1 = DateFormat('EEE, M/d/y').format(lastModDate1);

      int finalFileSize = filePath.lengthSync();
      String sizeInKb = (finalFileSize / (1024)).toStringAsFixed(2);
      PdfListModel pdfmodel = PdfListModel(
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

    List<FavouriteListPdfModel> tempValue =
        favouriteListPdfModelFromJson(jsonEncode(futurePDFList));
    print(tempValue);
    favoritePdfList = [];
    for (FavouriteListPdfModel file in tempValue) {
      File filePath = File(file.pdf.toString());
      String pdfname = filePath.path.split('/').last;

      DateTime lastModDate1 = filePath.lastModifiedSync();
      String formattedDate1 = DateFormat('EEE, M/d/y').format(lastModDate1);

      int finalFileSize = filePath.lengthSync();
      String sizeInKb = (finalFileSize / (1024)).toStringAsFixed(2);
      PdfListModel pdfmodel = PdfListModel(
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
      List<Map<String, Object?>> resultremoveFromRecentPdfList =
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
      List<Map<String, Object?>> resultRemoveFromFav =
          await dbClientRemoveFromFavorite.rawQuery(
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
      List<Map<String, Object?>> resultDelete = await dbClientDelete.rawQuery(
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
      List<Map<String, Object?>> resultDelete = await dbClientDelete.rawQuery(
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

    bool isExist = await _checkrecordExists(pdfPath.toString());

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
      List<Map<String, Object?>> result = await dbClient.rawQuery(
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

  deleteMethod(String fileName) {
    removeFromFavoritePdfList(fileName, SqlModel.tableFavorite);
    removeFromRecentPdfList(fileName, SqlModel.tableRecent);
    deleteFile(
      File(
        fileName,
      ),
    );
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
      // items.clear();
      // items.addAll(files);
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
    String root = storageInfo[0]
        .rootDir; //storageInfo[1] for SD card, geting the root directory
    FileManager fm = FileManager(root: Directory(root)); //
    List<File> temmpfiles = await fm.filesTree(
        excludedPaths: ["/storage/emulated/0/Android"],
        extensions: ["pdf"] //optional, to filter files, list only pdf files
        );

    files = [];
    for (File file in temmpfiles) {
      String pdfname = file.path.split('/').last;

      DateTime lastModDate1 = file.lastModifiedSync();
      String formattedDate = DateFormat('EEE, M/d/y').format(lastModDate1);

      int finalFileSize = file.lengthSync();
      String sizeInKb = (finalFileSize / (1024)).toStringAsFixed(2);
      PdfListModel pdfmodel = PdfListModel(
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
    items.clear();
    items.addAll(files);
    notifyListeners();
    print(files);
    //update the UI
  }

  changeFileNameOnly(
      BuildContext context, String newFileName, int index) async {
    print("------------->arrived new name----$newFileName--------");
    String temp1 = files[index].referenceFile!.path;

    int lastSeparator = temp1.lastIndexOf(Platform.pathSeparator);
    String newPath =
        temp1.substring(0, lastSeparator + 1) + newFileName + ".pdf";
    File filename = await files[index].referenceFile!.rename(newPath);

    files[index].referenceFile = filename;
    files[index].pdfpath = filename.path;

    files[index].pdfname = filename.path.split('/').last;

    bool renameFavCheck =
        favoritePdfList.where((element) => element.pdfpath == temp1).isNotEmpty;

    if (renameFavCheck == true) {
      removeFromFavoritePdfList(temp1, SqlModel.tableFavorite);
      insertIntoFavoritePdfList(newPath, SqlModel.tableFavorite);
    }

    bool renameRecentCheck =
        recentPdfList.where((element) => element.pdfpath == temp1).isNotEmpty;

    if (renameRecentCheck == true) {
      removeFromRecentPdfList(temp1, SqlModel.tableRecent);
      Map<String, Object> data = {
        'recentpdf': (newPath),
      };

      RecentSQLPDFService().insertRecentPDF(data, SqlModel.tableRecent);
    }
    getRecentPdfList();
    getStorageFilleMethod();
    notifyListeners();
  }
}
