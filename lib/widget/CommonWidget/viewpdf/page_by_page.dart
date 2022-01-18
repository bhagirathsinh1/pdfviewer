import 'package:flutter/material.dart';

class PageByPage extends StatefulWidget {
  PageByPage(
      {Key? key, required this.isContinuePage, required this.onValueChanged})
      : super(key: key);
  bool isContinuePage;
  final ValueChanged<bool> onValueChanged;

  @override
  _PageByPageState createState() => _PageByPageState();
}

class _PageByPageState extends State<PageByPage> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "Page by page",
        style: TextStyle(
          color: widget.isContinuePage
              ? Colors.blue.withOpacity(0.8)
              : Colors.black.withOpacity(0.8),
        ),
      ),
      leading: Icon(
        Icons.call_to_action_rounded,
        color: widget.isContinuePage
            ? Colors.blue.withOpacity(0.8)
            : Colors.black.withOpacity(0.5),
      ),
      onTap: () {
        setState(() {
          widget.onValueChanged(true);
        });
        Navigator.pop(context);
      },
    );
  }
}
