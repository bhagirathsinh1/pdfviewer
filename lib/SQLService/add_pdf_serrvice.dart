import 'package:pdfviewer/SQLService/sqlService.dart';

class SQLPDFService {
  Future<bool> insertPDF(dynamic data, table) async {
    final dbClient = await SqlModel().db;

    var isExist = await _checkrecordExists(data['pdf'].toString());

    if (!isExist) {
      try {
        var result = await dbClient.insert(table, data);

        print("----------insert pdf rsult add to fav page $result");

        return true;
      } catch (e) {
        // throw "asd";
        print(e);
        return false;
      }
    } else {
      throw "---------already exists---------";
    }
  }

  Future<bool> _checkrecordExists(String data) async {
    final dbClient = await SqlModel().db;
    // var user = await SaveData().getUserData();

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

  Future<bool> clearData(String table) async {
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

  Future<bool> removeFromFavorite(arrivdata, String table) async {
    final dbClientRemoveFromFavorite = await SqlModel().db;
    try {
      var resultRemoveFromFav = await dbClientRemoveFromFavorite.rawQuery(
        'DELETE FROM $table WHERE pdf = ?',
        [arrivdata],
      );
      print("deleted index $resultRemoveFromFav");

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
