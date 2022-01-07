import 'package:flutter/material.dart';

import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/service/singing_character_enum.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomePopupMenu extends StatefulWidget {
  @override
  State<HomePopupMenu> createState() => _HomePopupMenuState();
}

class _HomePopupMenuState extends State<HomePopupMenu> {
  SingingCharacter? _character;

  bool isNameSort = true;

  bool isDateSort = false;

  bool isSizeAccending = false;

  bool isSizeDeccending = false;

  bool isReverseSized = false;

  Widget build(BuildContext context) {
    return PopupMenuButton<SingingCharacter>(
      onSelected: (selectedRadio) async {
        print('--------------------------->1');
        switch (selectedRadio) {
          case SingingCharacter.isSizeAccendingRadio:
            {
              await Provider.of<PdfFileService>(context, listen: false)
                  .accendingSort();
              setState(() {
                _character = selectedRadio;
              });
            }
            break;
          case SingingCharacter.isSizeDeccendingRadio:
            {
              await Provider.of<PdfFileService>(context, listen: false)
                  .deccendingSort();
              setState(() {
                _character = selectedRadio;
              });
            }
            break;
          case SingingCharacter.nameRadio:
            {
              await Provider.of<PdfFileService>(context, listen: false)
                  .nameSort();
              setState(() {
                _character = selectedRadio;
              });
            }
            break;
          case SingingCharacter.dateRadio:
            {
              await Provider.of<PdfFileService>(context, listen: false)
                  .dateSort();
              setState(() {
                _character = selectedRadio;
              });
            }
            break;
          default:
        }
      },
      icon: Icon(
        Icons.menu,
        color: Colors.black,
      ),
      color: Colors.white,
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            print('--------------------------->2');
          },
          child: Row(
            children: [
              Radio<SingingCharacter>(
                value: SingingCharacter.isSizeAccendingRadio,
                groupValue: _character,
                onChanged: (SingingCharacter? value) async {
                  print('---------------------------3');

                  setState(() {
                    _character = value;
                  });
                },
              ),
              Text(
                "Size : Accending",
              )
            ],
          ),
          value: SingingCharacter.isSizeAccendingRadio,
        ),
        PopupMenuItem(
          onTap: () {},
          child: Row(
            children: [
              Radio<SingingCharacter>(
                value: SingingCharacter.isSizeDeccendingRadio,
                groupValue: _character,
                onChanged: (SingingCharacter? value) async {
                  if (isSizeDeccending == false) {
                    setState(() {
                      _character = value;
                    });
                  }
                },
              ),
              Text("Size : Deccending")
            ],
          ),
          value: SingingCharacter.isSizeDeccendingRadio,
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Radio<SingingCharacter>(
                value: SingingCharacter.nameRadio,
                groupValue: _character,
                onChanged: (SingingCharacter? value) async {
                  setState(() {
                    _character = value;
                  });
                },
              ),
              Text("Name")
            ],
          ),
          value: SingingCharacter.nameRadio,
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Radio<SingingCharacter>(
                value: SingingCharacter.dateRadio,
                groupValue: _character,
                onChanged: (SingingCharacter? value) async {
                  setState(() {
                    _character = value;
                  });
                },
              ),
              Text("Date")
            ],
          ),
          value: SingingCharacter.dateRadio,
        ),
      ],
    );
  }
}
