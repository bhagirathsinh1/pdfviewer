import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider_extention/path_provider_extention.dart';
import 'package:pdfviewer/pdfscreen.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:permission_handler/permission_handler.dart';

List<File> files = [];
List<File> duplicateItems = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = SqlModel();
  await db.initDb();
  var a = await db.creatingTables();
  print(a);
  runApp(
    MyApp(),
  );
}

void getFiles() async {
  //asyn function to get list of files
  List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
  var root = storageInfo[0]
      .rootDir; //storageInfo[1] for SD card, geting the root directory
  var fm = FileManager(root: Directory(root)); //
  files = await fm.filesTree(
      excludedPaths: ["/storage/emulated/0/Android"],
      extensions: ["pdf"] //optional, to filter files, list only pdf files
      );

  print(files);
  //update the UI
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool permissionGranted = false;
  bool permit = false;
  late int a;
  @override
  void initState() {
    _getStoragePermission();
    files.addAll(duplicateItems);

    super.initState();
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
      getFiles();
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("..............permit3............");
    print(permit);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AnimatedSplashScreen(
        splash: Icons.picture_as_pdf,
        duration: 3500,
        splashTransition: SplashTransition.scaleTransition,
        // pageTransitionType: PageTransitionType.scale,
        backgroundColor: Colors.lightBlue,
        nextScreen: pdfscreen(),
      ),
    );
  }
}
