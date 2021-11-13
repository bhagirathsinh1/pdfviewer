// To parse this JSON data, do
//
//     final favouriteListPdfModel = favouriteListPdfModelFromJson(jsonString);

import 'dart:convert';

List<FavouriteListPdfModel> favouriteListPdfModelFromJson(String str) =>
    List<FavouriteListPdfModel>.from(
        json.decode(str).map((x) => FavouriteListPdfModel.fromJson(x)));

String favouriteListPdfModelToJson(List<FavouriteListPdfModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FavouriteListPdfModel {
  FavouriteListPdfModel({
    this.autoId,
    this.pdf,
  });

  int? autoId;
  String? pdf;

  factory FavouriteListPdfModel.fromJson(Map<String, dynamic> json) =>
      FavouriteListPdfModel(
        autoId: json["auto_id"],
        pdf: json["pdf"],
      );

  Map<String, dynamic> toJson() => {
        "auto_id": autoId,
        "pdf": pdf,
      };
}
