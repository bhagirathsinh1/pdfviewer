// To parse this JSON data, do
//
//     final pdfListModel = pdfListModelFromJson(jsonString);

import 'dart:convert';

List<PdfListModel> pdfListModelFromJson(String str) => List<PdfListModel>.from(
    json.decode(str).map((x) => PdfListModel.fromJson(x)));

String pdfListModelToJson(List<PdfListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PdfListModel {
  PdfListModel({
    this.pdfname,
    this.pdfpath,
    this.pdfindex,
    this.date,
    this.size,
  });

  String? pdfname;
  String? pdfpath;
  int? pdfindex;
  String? date;
  String? size;

  factory PdfListModel.fromJson(Map<String, dynamic> json) => PdfListModel(
        pdfname: json["pdfname"] == null ? null : json["pdfname"],
        pdfpath: json["pdfpath"] == null ? null : json["pdfpath"],
        pdfindex: json["pdfindex"] == null ? null : json["pdfindex"],
        date: json["date"] == null ? null : json["date"],
        size: json["size"] == null ? null : json["size"],
      );

  Map<String, dynamic> toJson() => {
        "pdfname": pdfname == null ? null : pdfname,
        "pdfpath": pdfpath == null ? null : pdfpath,
        "pdfindex": pdfindex == null ? null : pdfindex,
        "date": date == null ? null : date,
        "size": size == null ? null : size,
      };
}
