import 'package:flutter/material.dart';

class RenameFileDialouge extends StatefulWidget {
  final String fileName;
  final Function callback;

  RenameFileDialouge({Key? key, required this.fileName, required this.callback})
      : super(key: key);

  @override
  _RenameFileDialougeState createState() => _RenameFileDialougeState();
}

class _RenameFileDialougeState extends State<RenameFileDialouge> {
  bool isLoading = false;

  final _formKeyRenameFile = GlobalKey<FormState>();
  TextEditingController renameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    renameController.text = widget.fileName.split('/').last.split('.pdf').first;
  }

  // set up the AlertDialog
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Alert!"),
      content: Container(
        height: 70,
        child: Form(
          key: _formKeyRenameFile,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: renameController,
                validator: (value) {
                  if (value != null && value != "") {
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
                // Only numbers can be entered
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    helperText: 'Enter new name here '),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text("CANCEL"),
          onPressed: () {
            Future.delayed(Duration(milliseconds: 10), () async {
              Navigator.pop(context);
            });
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () {
            var newFileName = renameController.text;
            widget.callback(newFileName);
            Future.delayed(Duration(milliseconds: 10), () {
              Navigator.pop(context);
            });
            // });
          },
          child: Text(
            'OK',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
