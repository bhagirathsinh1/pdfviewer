import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:pdfviewer/widget/CommonWidget/page_view.dart';

class BrowsMoreFilePopUp extends StatefulWidget {
  BrowsMoreFilePopUp({
    Key? key,
  }) : super(key: key);

  @override
  _BrowsMoreFilePopUpState createState() => _BrowsMoreFilePopUpState();
}

class _BrowsMoreFilePopUpState extends State<BrowsMoreFilePopUp> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
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
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result == null) {
                          Navigator.pop(context);
                        } else {
                          print(
                              "------picked file--->/${result.files.single.path.toString()}------");
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       // return ViewPDF(
                          //       //   pathPDF: result.files.single.path.toString(),
                          //       // );
                          //       return ViewPDF(
                          //           pathPDF:
                          //               result.files.single.path.toString(),
                          //           );
                          //     },
                          //   ),
                          // );
                        }
                      },
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
        ));
  }
}
