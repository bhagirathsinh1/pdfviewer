import 'package:flutter/material.dart';
import 'package:pdfviewer/dialogue/delete_dialouge.dart';

class DeleteFileWidget extends StatelessWidget {
  final int index;
  final String fileName;
  const DeleteFileWidget({
    Key? key,
    required this.index,
    required this.fileName,
  }) : super(key: key);
  // final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
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
      onTap: () {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return new DeleteFileDialouge(
                index: index,
                fileName: fileName,
              );
            });
      },
    );
  }
}
