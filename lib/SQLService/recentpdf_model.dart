// To parse this JSON data, do
//
//     final recentListPdfModel = recentListPdfModelFromJson(jsonString);

import 'dart:convert';

List<RecentListPdfModel> recentListPdfModelFromJson(String str) =>
    List<RecentListPdfModel>.from(
        json.decode(str).map((x) => RecentListPdfModel.fromJson(x)));

String recentListPdfModelToJson(List<RecentListPdfModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecentListPdfModel {
  RecentListPdfModel({
    this.autoId,
    this.recentpdf,
  });

  int? autoId;
  String? recentpdf;

  factory RecentListPdfModel.fromJson(Map<String, dynamic> json) =>
      RecentListPdfModel(
        autoId: json["auto_id"],
        recentpdf: json["recentpdf"],
      );

  Map<String, dynamic> toJson() => {
        "auto_id": autoId,
        "recentpdf": recentpdf,
      };
}
