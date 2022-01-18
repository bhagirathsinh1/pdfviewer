import 'package:flutter/material.dart';

class PrintWidget extends StatelessWidget {
  const PrintWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "Print",
        style: TextStyle(
          color: Colors.black.withOpacity(0.8),
        ),
      ),
      leading: Icon(
        Icons.local_print_shop_rounded,
        color: Colors.black.withOpacity(0.5),
      ),
      onTap: () {},
    );
  }
}
