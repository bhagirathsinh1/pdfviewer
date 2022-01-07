import 'package:flutter/material.dart';

class TitleOfPdf extends StatelessWidget {
  const TitleOfPdf({Key? key, required this.titlePath}) : super(key: key);
  final String titlePath;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.yellow[100],
          border: Border.all(
            color: Colors.grey,
            width: 5,
          )),
      child: ListTile(
        title: Text(
          titlePath,
          style: TextStyle(
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        leading: Icon(
          Icons.picture_as_pdf,
          color: Colors.red,
        ),
        onTap: () {},
      ),
    );
  }
}
