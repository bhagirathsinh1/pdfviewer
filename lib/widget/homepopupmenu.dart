import 'package:flutter/material.dart';

import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/service/singing_character_enum.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomePopupMenu extends StatelessWidget {
  SingingCharacter? _character;

  bool isNameSort = false;
  bool isDateSort = false;
  bool isSizeAccending = false;
  bool isSizeDeccending = false;
  bool isReverseSized = false;

  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.menu,
        color: Colors.black,
      ),
      color: Colors.white,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Row(
            children: [
              Radio<SingingCharacter>(
                value: SingingCharacter.isSizeAccendingRadio,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  Provider.of<PdfFileService>(context, listen: false)
                      .sortingPdfMethod(true, true, false, false, false,
                          context, SingingCharacter.isSizeAccendingRadio);

                  Text("Size : Accending");
                },
              ),
            ],
          ),
          value: 1,
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Radio<SingingCharacter>(
                value: SingingCharacter.isSizeDeccendingRadio,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  if (isSizeDeccending == false) {
                    try {
                      Future.delayed(
                        const Duration(milliseconds: 200),
                        () async {
                          Provider.of<PdfFileService>(context, listen: false)
                              .files
                              .sort(
                            (b, a) {
                              return a.lengthSync().compareTo(b.lengthSync());
                            },
                          );
                        },
                      );
                    } catch (e) {
                      print('-------------------> error ---> $e');
                    }
                  }

                  _character = value;
                  isReverseSized = false;
                  isSizeDeccending = true;
                  isSizeAccending = false;
                  isNameSort = false;
                  isDateSort = false;

                  Navigator.pop(context);
                },
              ),
              Text("Size : Deccending")
            ],
          ),
          value: 2,
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Radio<SingingCharacter>(
                value: SingingCharacter.nameRadio,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  if (isNameSort == false) {
                    print("...........MyApp.files1..................");
                    print(Provider.of<PdfFileService>(context, listen: false)
                        .files);

                    try {
                      Future.delayed(
                        const Duration(milliseconds: 200),
                        () async {
                          Provider.of<PdfFileService>(context, listen: false)
                              .files
                              .sort(
                            (a, b) {
                              return a.path
                                  .toLowerCase()
                                  .split('/')
                                  .last
                                  .compareTo(
                                      b.path.toLowerCase().split('/').last);
                            },
                          );
                        },
                      );
                    } catch (e) {
                      print('-------------------> error ---> $e');
                    }
                  }

                  _character = value;
                  isReverseSized = false;
                  isSizeAccending = false;
                  isSizeDeccending = false;
                  isNameSort = true;
                  isDateSort = false;
                  Navigator.pop(context);
                },
              ),
              Text("Name")
            ],
          ),
          value: 3,
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Radio<SingingCharacter>(
                value: SingingCharacter.dateRadio,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  if (isDateSort == false) {
                    try {
                      Future.delayed(
                        const Duration(milliseconds: 200),
                        () async {
                          Provider.of<PdfFileService>(context, listen: false)
                              .files
                              .sort(
                            (b, a) {
                              return a
                                  .lastModifiedSync()
                                  .compareTo(b.lastModifiedSync());
                            },
                          );
                        },
                      );
                    } catch (e) {
                      print('-------------------> error ---> $e');
                    }
                  }

                  _character = value;
                  isReverseSized = false;
                  isSizeAccending = false;
                  isSizeDeccending = false;
                  isDateSort = true;
                  isNameSort = false;
                  Navigator.pop(context);
                },
              ),
              Text("Date")
            ],
          ),
          value: 4,
        ),
      ],
    );
  }
}
