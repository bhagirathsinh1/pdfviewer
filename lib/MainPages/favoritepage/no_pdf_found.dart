import 'package:flutter/material.dart';

class NoPdfFound extends StatelessWidget {
  const NoPdfFound({Key? key, required this.listName}) : super(key: key);
  final String listName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: 200,
            width: 200,
            decoration: new BoxDecoration(
                image: new DecorationImage(
              image: new AssetImage("assets/icon/empty_image.gif"),
              fit: BoxFit.fill,
            ))),
        Text(
          "No $listName pdf found!!",
          style: TextStyle(color: Colors.grey.shade600),
        )
      ],
    );
  }
}
