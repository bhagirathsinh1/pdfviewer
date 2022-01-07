import "dart:io" as io;
import 'package:flutter/material.dart';
import "package:path/path.dart";
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqlModel {
  static final SqlModel _instance = new SqlModel.internal();
  factory SqlModel() => _instance;
  static late Database _db;

// TABLE NAMES
  static final tableFavorite = 'tableFavorite';
  static final tableRecent = 'tableRecent';

  /// Initialize DB
  Future initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "myDatabase2.db");
    var taskDb = await openDatabase(path, version: 1);

    _db = taskDb;
    await creatingTables();

    return taskDb;
  }

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  SqlModel.internal();

  Future creatingTables() async {
    try {
      var dbClient = await SqlModel().db;

      dbClient.execute("""
     CREATE TABLE IF NOT EXISTS $tableFavorite(
        auto_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        pdf TEXT)
      """);
      dbClient.execute("""
     CREATE TABLE IF NOT EXISTS $tableRecent(
        auto_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        recentpdf TEXT)
      """);
      return "tables created";
    } catch (e) {
      debugPrint(e.toString());
      return "table already exists";
    }
  }
}
