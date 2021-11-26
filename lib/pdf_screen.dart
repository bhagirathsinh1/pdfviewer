import 'dart:io';

import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:pdfviewer/favourite_page.dart';
import 'package:pdfviewer/home_page.dart';
import 'package:pdfviewer/main.dart';
import 'package:pdfviewer/recent_page.dart';

class Pdfscreen extends StatefulWidget {
  @override
  State<Pdfscreen> createState() => _PdfscreenState();
}

class _PdfscreenState extends State<Pdfscreen> {
  int _currentPage = 0;
  static bool _init = false;
  get inits => _init;
  bool willpop = false;

  final _pageController = PageController(keepPage: false);
  TextEditingController textController = TextEditingController();
  @override
  void initState() {
    getFiles();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return exit(0);
      },
      child: Scaffold(
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

            setState(() {
              _init = true;
              _currentPage = index;
            });
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

  Future<void> bottomNavBar(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 230,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  "Brows More file",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.folder,
                  color: Colors.black.withOpacity(0.5),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  "Rate Us",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.star,
                  color: Colors.black.withOpacity(0.5),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  "Share this app",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.share,
                  color: Colors.black.withOpacity(0.5),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  "Privacy Policy",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.privacy_tip,
                  color: Colors.black.withOpacity(0.5),
                ),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}