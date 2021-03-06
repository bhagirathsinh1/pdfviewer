import 'package:pdfviewer/SQLService/recent_pdf_model.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';

class RecentSQLPDFService {
  Future insertRecentPDF(dynamic data, table) async {
    final dbClient = await SqlModel().db;

    bool isExist = await _checkrecordExists(data['recentpdf'].toString());

    if (!isExist) {
      try {
        int result = await dbClient.insert(table, data);

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

    try {
      List<Map<String, Object?>> result = await dbClient.rawQuery(
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
}
