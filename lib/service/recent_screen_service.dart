import 'package:flutter/widgets.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';

class RecentService with ChangeNotifier {
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

  Future<bool> clearRecentPdfData(String table) async {
    final dbClientDelete = await SqlModel().db;
    try {
      var resultDelete = await dbClientDelete.rawQuery(
          """DELETE FROM $table""").whenComplete(() => notifyListeners());
      print("deleted result $resultDelete");

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
