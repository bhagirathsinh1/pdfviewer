import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class permission_page extends StatefulWidget {
  @override
  _permission_pageState createState() => _permission_pageState();
}

class _permission_pageState extends State<permission_page> {
  @override
  void initState() {
    SystemNavigator.pop(); //call getFiles() function on initial state.
    super.initState();
    print("-----------------------------> called homepage Initstate");
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
