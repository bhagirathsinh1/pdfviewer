import 'package:flutter/material.dart';
import 'package:pdfviewer/dialogue/rename_dialouge.dart';

class RenameFileWidget extends StatelessWidget {
  //remove index
  final int index;
  final String fileName;
  const RenameFileWidget({
    Key? key,
    required this.index,
    required this.fileName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return new RenameFileDialouge(
              index: index, // remove index
              fileName: fileName,
            );
          },
        );
      },
    );
  }
}
