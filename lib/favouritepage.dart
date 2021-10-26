import 'package:flutter/material.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
// import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

List<String> favorite_list = [];
List<String> reversed_favorite_list = [];

class Favouritepage extends StatefulWidget {
  const Favouritepage({Key? key}) : super(key: key);

  @override
  _FavouritepageState createState() => _FavouritepageState();
}

class _FavouritepageState extends State<Favouritepage> {
  @override
  void initState() {
    super.initState();
    reversed_favorite_list = favorite_list.reversed.toList();
  }

  var newindex;
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
          ///search button

          ///more

          IconButton(
            onPressed: () {
              // favoriteBottomNavBar(context);
              favoriteBottomNavBar(context);
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        //if file/folder list is grabbed, then show here
        itemCount: reversed_favorite_list.length,

        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(reversed_favorite_list[index].split('/').last),
              leading: Icon(Icons.picture_as_pdf),
              trailing: IconButton(
                onPressed: () {
                  newindex = index;
                  favNavDrawer(context);
                },
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.redAccent,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ViewPDF(
                        pathPDF: reversed_favorite_list[index].toString(),
                      );
                      //open viewPDF page on click
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> favNavDrawer(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 350,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    border: Border.all(
                      color: Colors.grey,
                      width: 5,
                    )),
                child: ListTile(
                  title: Text(
                    reversed_favorite_list[newindex].split('/').last,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  leading: Icon(
                    Icons.picture_as_pdf,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  onTap: () {},
                ),
              ),
              ListTile(
                title: Text(
                  "Share",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.share,
                  color: Colors.black.withOpacity(0.5),
                ),
                onTap: () {
                  setState(() {
                    // order = !order;
                  });
                },
              ),
              ListTile(
                title: Text(
                  "Add to favorite",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.star,
                  color: Colors.black.withOpacity(0.5),
                ),
                onTap: () {
                  // if (favorite_list.contains(files[favorite_index].path)) {
                  //   Navigator.pop(context);
                  //   ScaffoldMessenger.of(context).clearSnackBars();
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: Text("Already added !!"),
                  //     ),
                  //   );
                  // } else {
                  //   favorite_list.add(files[favorite_index].path);
                  //   Navigator.pop(context);
                  //   ScaffoldMessenger.of(context).clearSnackBars();
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: Text("Successfully added !!"),
                  //     ),
                  //   );
                  // }
                },
              ),
              ListTile(
                title: Text(
                  "Rename",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.edit,
                  color: Colors.black.withOpacity(0.5),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.delete,
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

  Future<void> favoriteBottomNavBar(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 70,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  "Clear Recents",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                leading: Icon(
                  Icons.delete,
                  color: Colors.black.withOpacity(0.5),
                ),
                onTap: () {
                  setState(() {
                    favorite_list.clear();
                    reversed_favorite_list.clear();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class ViewPDF extends StatelessWidget {
  String pathPDF = "";
  ViewPDF({required this.pathPDF});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PDF Reader",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: PdfView(path: pathPDF),
      ),
    );
  }
}
