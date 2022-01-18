import 'package:flutter/material.dart';

class NightMode extends StatelessWidget {
  const NightMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "Night Mode",
        style: TextStyle(
          color: Colors.black.withOpacity(0.8),
        ),
      ),
      leading: Icon(
        Icons.nights_stay,
        color: Colors.black.withOpacity(0.5),
      ),
      onTap: () {},
    );
  }
}
