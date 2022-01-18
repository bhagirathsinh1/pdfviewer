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
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: isLoading
              ? Center(
                  child: SizedBox(
                    child: Text('Loading...'),
                    height: 20,
                    width: 20,
                  ),
                )
              : Text("OK"),
          onPressed: () async {
            setState(() {
              isLoading = true;
            });
            var newFileName = renameController.text;

            print(newFileName.split('.'));
            await widget.callback(newFileName);

            setState(() {
              isLoading = false;
            });
            Navigator.pop(context);
            showAlertDialog(context);
          },
        )
      ],
    );
  }

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Succesfuly rename"),
          content: Text(renameController.text),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
    // Navigator.pop(context);
  }
}
