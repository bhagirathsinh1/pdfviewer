// import 'package:flutter/material.dart';

// ///
// /// Widget for displaying loading animation and doing background work at the same time.
// ///
// class splashscreen extends StatefulWidget {
//   splashscreen(this.child, this.toProcess, {required this.backgroundColor});

//   final Function() toProcess;
//   final Widget child;
//   final Color backgroundColor;

//   @override
//   _splashscreenState createState() => _splashscreenState();
// }

// class _splashscreenState extends State<splashscreen> {
//   @override
//   void initState() {
//     super.initState();
//     widget.toProcess();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: getBackgroundColor(),
//       child: widget.child,
//     );
//   }

//   Color getBackgroundColor() {
//     return widget.backgroundColor == null
//         ? Theme.of(context).backgroundColor
//         : widget.backgroundColor;
//   }
// }
