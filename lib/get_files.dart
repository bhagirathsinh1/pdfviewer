import 'package:flutter/material.dart';

class PopUpMenu extends StatelessWidget {
  const PopUpMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuMethod();
  }

  PopupMenuButton<int> PopupMenuMethod() {
    return PopupMenuButton(
      icon: Icon(
        Icons.menu,
        color: Colors.black,
      ),
      color: Colors.white,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text("Date"),
          value: 1,
        ),
        PopupMenuItem(
          child: Text("Name"),
          value: 2,
        ),
        PopupMenuItem(
          child: Text("Size"),
          value: 3,
        )
      ],
    );
  }
}
