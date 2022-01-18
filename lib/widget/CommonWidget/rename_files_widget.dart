import 'package:flutter/material.dart';
import 'package:pdfviewer/dialogue/rename_dialouge.dart';

class RenameFileWidget extends StatelessWidget {
  //remove index
  final String fileName;
  final Function callback;
  const RenameFileWidget(
      {Key? key, required this.fileName, required this.callback})
      : super(key: key);

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
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return new RenameFileDialouge(
              callback: callback,
              fileName: fileName,
            );
          },
        );
      },
    );
  }
}
