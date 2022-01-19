import 'package:flutter/material.dart';

import 'package:pdfviewer/service/pdf_file_service.dart';
import 'package:pdfviewer/service/sorting_enum.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Shorting extends StatefulWidget {
  @override
  State<Shorting> createState() => _ShortingState();
}

class _ShortingState extends State<Shorting> {
  Sortingenum? _character;

  bool isNameSort = true;

  bool isDateSort = false;

  bool isSizeAccending = false;

  bool isSizeDeccending = false;

  bool isReverseSized = false;

  Widget build(BuildContext context) {
    return PopupMenuButton<Sortingenum>(
      onSelected: (selectedRadio) async {
        print('--------------------------->1');
        switch (selectedRadio) {
          case Sortingenum.isSizeAccendingRadio:
            {
              await Provider.of<PdfFileService>(context, listen: false)
                  .accendingSort();
              setState(() {
                _character = selectedRadio;
              });
            }
            break;
          case Sortingenum.isSizeDeccendingRadio:
            {
              await Provider.of<PdfFileService>(context, listen: false)
                  .deccendingSort();
              setState(() {
                _character = selectedRadio;
              });
            }
            break;
          case Sortingenum.nameRadio:
            {
              await Provider.of<PdfFileService>(context, listen: false)
                  .nameSort();
              setState(() {
                _character = selectedRadio;
              });
            }
            break;
          case Sortingenum.dateRadio:
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
              Radio<Sortingenum>(
                value: Sortingenum.isSizeAccendingRadio,
                groupValue: _character,
                onChanged: (Sortingenum? value) async {
                  print('---------------------------3');

                  setState(() {
                    _character = value;
                  });
                },
              ),
              Text(
                "Size (smallest first)",
              )
            ],
          ),
          value: Sortingenum.isSizeAccendingRadio,
        ),
        PopupMenuItem(
          onTap: () {},
          child: Row(
            children: [
              Radio<Sortingenum>(
                value: Sortingenum.isSizeDeccendingRadio,
                groupValue: _character,
                onChanged: (Sortingenum? value) async {
                  if (isSizeDeccending == false) {
                    setState(() {
                      _character = value;
                    });
                  }
                },
              ),
              Text("Size (largest first)")
            ],
          ),
          value: Sortingenum.isSizeDeccendingRadio,
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Radio<Sortingenum>(
                value: Sortingenum.nameRadio,
                groupValue: _character,
                onChanged: (Sortingenum? value) async {
                  setState(() {
                    _character = value;
                  });
                },
              ),
              Text("Name")
            ],
          ),
          value: Sortingenum.nameRadio,
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Radio<Sortingenum>(
                value: Sortingenum.dateRadio,
                groupValue: _character,
                onChanged: (Sortingenum? value) async {
                  setState(() {
                    _character = value;
                  });
                },
              ),
              Text("Date")
            ],
          ),
          value: Sortingenum.dateRadio,
        ),
      ],
    );
  }
}
