import 'package:pdfviewer/SQLService/sqlService.dart';

class RecentSQLPDFService {
  Future insertRecentPDF(dynamic data, table) async {
    final dbClient = await SqlModel().db;

    var isExist = await _checkrecordExists(data['recentpdf'].toString());

    if (!isExist) {
      try {
        var result = await dbClient.insert(table, data);

        print("result $result");

        return true;
      } catch (e) {
        print(e);
        return false;
      }
    }
  }

  Future<bool> _checkrecordExists(String data) async {
    final dbClient = await SqlModel().db;
    // var user = await SaveData().getUserData();

    try {
      var result = await dbClient.rawQuery(
          """select *from ${SqlModel.tableRecent} where recentpdf= '$data'""");

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
