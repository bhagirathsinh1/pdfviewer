import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:pdfviewer/pdf_screen.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

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

class MyApp extends StatefulWidget {
  @override
  static List<File> duplicateItems = [];

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isPermissionGranted = false;
  bool permit = false;
  late int a;
  @override
  void initState() {
    _getStoragePermission();
    // Provider.of<PdfFileService>(context, listen: false)
    //     .files
    //     .addAll(MyApp.duplicateItems);

    super.initState();
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(
        () {
          isPermissionGranted = true;
        },
      );
      Provider.of<PdfFileService>(context, listen: false).getFiles();
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(
        () {
          isPermissionGranted = false;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("..............permit3............");
    print(permit);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PdfFileService>(create: (_) => PdfFileService()),
      ],
      child: MaterialApp(
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
          nextScreen: Pdfscreen(),
        ),
      ),
    );
  }
}
