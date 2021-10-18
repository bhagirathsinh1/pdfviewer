import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:pdfviewer/favouritepage.dart';
import 'package:pdfviewer/homepage.dart';
import 'package:pdfviewer/recentpage.dart';

class pdfscreen extends StatefulWidget {
  @override
  State<pdfscreen> createState() => _pdfscreenState();
}

class _pdfscreenState extends State<pdfscreen> {
  int _currentPage = 0;

  final _pageController = PageController();
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "PDF Reader",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            // Within the `FirstRoute` widget
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => search(),
              //   ),
              // );
            },
            icon: Icon(
              Icons.search,
              size: 26.0,
              color: Colors.black,
            ),
          ),
          PopupMenuButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Date"),
                value: 1,
              ),
              PopupMenuItem(
                child: Text("Name"),
                value: 2,
              ),
              PopupMenuItem(
                child: Text("Size"),
                value: 3,
              )
            ],
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
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
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: [
          Homepage(),
          Recentpage(),
          Favouritepage(),
        ],
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _currentPage,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() => _currentPage = index);
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
    );
  }
}
