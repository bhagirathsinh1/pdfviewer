import 'package:pdfviewer/SQLService/sqlService.dart';

class SQLPDFService {
  Future<bool> insertPDF(dynamic data, table) async {
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

  Future<List<Map<String, Object?>>> getAllPDF(String table) async {
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
