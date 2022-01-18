import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ShareFiles extends StatefulWidget {
  const ShareFiles({
    Key? key,
    required this.fileName,
  }) : super(key: key);
  final String fileName;
  // final snapshot;

  @override
  State<ShareFiles> createState() => _ShareFilesState();
}

class _ShareFilesState extends State<ShareFiles> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
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
        Share.shareFiles([widget.fileName]);
      },
    );
  }
}
