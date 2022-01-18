import 'package:flutter/material.dart';

class ContinuePage extends StatefulWidget {
  ContinuePage(
      {Key? key, required this.isContinuePage, required this.onValueChanged})
      : super(key: key);
  bool isContinuePage;
  final ValueChanged<bool> onValueChanged;

  @override
  _GoToPageState createState() => _GoToPageState();
}

class _GoToPageState extends State<ContinuePage> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "Continuous page",
        style: TextStyle(
          color: widget.isContinuePage
              ? Colors.black.withOpacity(0.8)
              : Colors.blue.withOpacity(0.8),
        ),
      ),
      leading: Icon(
        Icons.print,
        color: widget.isContinuePage
            ? Colors.black.withOpacity(0.5)
            : Colors.blue.withOpacity(0.8),
      ),
      onTap: () {
        setState(() {
          widget.onValueChanged(false);
        });
        Navigator.pop(context);
      },
    );
  }
}
