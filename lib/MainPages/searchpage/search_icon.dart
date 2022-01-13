import 'package:flutter/material.dart';
import 'package:pdfviewer/MainPages/searchpage/search_page.dart';

class SearchIcon extends StatelessWidget {
  const SearchIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        );
      },
      icon: Icon(
        Icons.search,
        size: 26.0,
        color: Colors.black,
      ),
    );
  }
}
