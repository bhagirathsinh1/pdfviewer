import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/recentpage.dart';

class RecentSQLPDFService {
  Future<bool> insertRecentPDF(dynamic data, table) async {
    final dbClient = await SqlModel().db;
    try {
      var result = await dbClient.insert(table, data);

      print("result $result");

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> clearRecentPdfData(String table) async {
    final dbClientDelete = await SqlModel().db;
    try {
      var resultDelete =
          await dbClientDelete.rawQuery("""DELETE FROM $table""");
      print("deleted result $resultDelete");

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> removeFromRecent(arrivedataRecent, String table) async {
    final dbClientRemoveFromRecent = await SqlModel().db;
    try {
      var resultRemoveFromRecent = await dbClientRemoveFromRecent.rawQuery(
        'DELETE FROM $table WHERE recentpdf = ?',
        [arrivedataRecent],
      );
      print("deleted in recent index $resultRemoveFromRecent");

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Map<String, Object?>>> getAllRecentPDF(String table) async {
    final dbClient = await SqlModel().db;

    try {
      var result = await dbClient.rawQuery("select *from $table");

      print("result $result");
      return result;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
