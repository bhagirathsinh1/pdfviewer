// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class FavoriteStarIcon extends StatefulWidget {
  dynamic isfav;
  FavoriteStarIcon({Key? key, required this.isfav}) : super(key: key);

  @override
  _FavoriteStarIconState createState() => _FavoriteStarIconState();
}

class _FavoriteStarIconState extends State<FavoriteStarIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {},
      constraints: BoxConstraints(),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      icon: Icon(
        Icons.star,
        color: widget.isfav.isEmpty ? Colors.transparent : Colors.blue,
      ),
    );
  }
}
