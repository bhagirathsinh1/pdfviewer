import 'package:flutter/material.dart';
import 'package:pdfviewer/pdfscreen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool permit = false;
  late int a;
  @override
  void initState() {
    print("..............permit1............");
    print(permit);
    Permission.storage.request();
    if (Permission.storage.request().isGranted == true) {
      setState(() {
        permit == true;
        print("..............permit2............");
        print(permit);
      });
      // Either the permission was already granted before or the user just granted it.
    } else {
      setState(() {});
    }

// You can request multiple permissions at once.
    // Map<Permission, PermissionStatus> statuses = await [
    //   Permission.location,
    //   Permission.storage,
    // ].request();
    // print(statuses[Permission.storage]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("..............permit3............");
    print(permit);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: pdfscreen());
  }
}
