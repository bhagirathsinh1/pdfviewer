import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:pdfviewer/MainPages/pdf_screen.dart';
import 'package:pdfviewer/SQLService/sqlService.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SqlModel().initDb();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
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
          home: MainClass()),
    );
  }
}

class MainClass extends StatefulWidget {
  const MainClass({Key? key}) : super(key: key);

  @override
  _MainClassState createState() => _MainClassState();
}

class _MainClassState extends State<MainClass> {
  bool isPermissionGranted = false;
  bool permit = false;
  late int a;
  @override
  void initState() {
    _getStoragePermission();

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
    return AnimatedSplashScreen(
      splash: Icons.picture_as_pdf,
      duration: 3500,
      splashTransition: SplashTransition.scaleTransition,
      // pageTransitionType: PageTransitionType.scale,
      backgroundColor: Colors.lightBlue,
      nextScreen: Pdfscreen(),
    );
  }
}
