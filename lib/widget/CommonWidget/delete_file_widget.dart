import 'package:flutter/material.dart';
import 'package:pdfviewer/dialogue/delete_dialouge.dart';

class DeleteFileWidget extends StatelessWidget {
  final String fileName;
  const DeleteFileWidget({
    Key? key,
    required this.fileName,
  }) : super(key: key);
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
                fileName: fileName,
              );
            });
      },
    );
  }
}
