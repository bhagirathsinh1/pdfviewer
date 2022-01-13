import 'dart:io';

import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:pdfviewer/MainPages/favoritepage/favourite_page.dart';
import 'package:pdfviewer/MainPages/homepage/home_page.dart';
import 'package:pdfviewer/MainPages/recentpage/recent_page.dart';
import 'package:pdfviewer/MainPages/searchpage/search_list.dart';
import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:provider/provider.dart';

class Pdfscreen extends StatefulWidget {
  @override
  State<Pdfscreen> createState() => _PdfscreenState();
}

class _PdfscreenState extends State<Pdfscreen> {
  PdfFileService getPdfObject = new PdfFileService();
  int _currentPage = 0;
  static bool _init = false;
  get inits => _init;
  bool willpop = false;

  final _pageController = PageController(keepPage: false);
  TextEditingController textController = TextEditingController();
  @override
  void initState() {
    var pdfService = Provider.of<PdfFileService>(context, listen: false);
    pdfService.items.addAll(pdfService.files);
    pdfService.getFavoritePdfList();
    pdfService.getRecentPdfList();
    pdfService.getStorageFilleMethod();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return exit(0);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: PageView(
          controller: _pageController,
          children: [
            Homepage(),
            Recentpage(),
            Favouritepage(),
          ],
          onPageChanged: (index) {
            _init = true;
            setState(
              () => _currentPage = index,
            );
          },
        ),
        bottomNavigationBar: BottomBar(
          selectedIndex: _currentPage,
          onTap: (int index) {
            _pageController.jumpToPage(index);

            setState(
              () {
                _init = true;
                _currentPage = index;
              },
            );
          },
          items: <BottomBarItem>[
            BottomBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: Colors.blue,
            ),
            BottomBarItem(
              icon: Icon(Icons.lock_clock),
              title: Text('Recent'),
              activeColor: Colors.blue,
            ),
            BottomBarItem(
              icon: Icon(Icons.favorite),
              title: Text('Favorites'),
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
