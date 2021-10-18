import 'package:flutter/material.dart';

class Recentpage extends StatefulWidget {
  const Recentpage({Key? key}) : super(key: key);

  @override
  _RecentpageState createState() => _RecentpageState();
}

class _RecentpageState extends State<Recentpage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("In recent page"),
      ),
    );
  }
}
