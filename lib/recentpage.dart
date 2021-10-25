import 'package:flutter/material.dart';
import 'package:pdfviewer/favouritepage.dart';

List<String> recent_list = [];
List<String> reversed_recent_list = [];

class Recentpage extends StatefulWidget {
  const Recentpage({Key? key}) : super(key: key);

  @override
  _RecentpageState createState() => _RecentpageState();
}

class _RecentpageState extends State<Recentpage> {
  var recent_index;

  @override
  void initState() {
    super.initState();
    reversed_recent_list = recent_list.reversed.toList();
  }

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
              recentBottomSheet(context);
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
        itemCount: reversed_recent_list.length,

        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(reversed_recent_list[index].split('/').last),
              leading: Icon(Icons.picture_as_pdf),
              trailing: IconButton(
                onPressed: () {
                  recent_index = index;
                  recentBottomBar(context);
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
                        pathPDF: reversed_recent_list[index].toString(),
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

  Future<void> recentBottomBar(BuildContext context) {
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
                    reversed_recent_list[recent_index].split('/').last,
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

  Future<void> recentBottomSheet(BuildContext context) {
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
                    recent_list.clear();
                    reversed_recent_list.clear();
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

// class ViewPDF extends StatelessWidget {
//   String pathPDF = "";
//   ViewPDF({required this.pathPDF});

//   @override
//   Widget build(BuildContext context) {
//     return PDFViewerScaffold(
//         //view PDF
//         appBar: AppBar(
//           title: Text("Documentss"),
//           backgroundColor: Colors.deepOrangeAccent,
//         ),
//         path: pathPDF);
//   }
// }
