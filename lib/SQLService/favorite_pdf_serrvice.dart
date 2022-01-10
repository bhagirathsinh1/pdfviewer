// import 'package:pdfviewer/SQLService/sqlService.dart';

// class SQLPDFService {
//   Future<List<Map<String, Object?>>> getAllPDF(String table) async {
//     final dbClient = await SqlModel().db;

//     try {
//       var result = await dbClient.rawQuery("select *from $table");

//       print("result $result");
//       return result;
//     } catch (e) {
//       print(e);
//       return [];
//     }
//   }
// }
