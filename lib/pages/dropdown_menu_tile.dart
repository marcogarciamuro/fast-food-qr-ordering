import 'package:flutter/material.dart';

class DropdownMenuTile extends StatefulWidget {
  const DropdownMenuTile(
      {Key? key,
      required this.menuLabel,
      required this.menuImage,
      required this.menuItems})
      : super(key: key);
  final String menuLabel;
  final String menuImage;
  final List menuItems;

  @override
  State<DropdownMenuTile> createState() => _DropdownMenuTileState();
}

class _DropdownMenuTileState extends State<DropdownMenuTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedTextColor: Colors.black,
      textColor: Colors.black,
      iconColor: Colors.black,
      tilePadding: const EdgeInsets.symmetric(horizontal: 20),
      collapsedIconColor: Colors.black,
      title: const Text('hello'),
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 40,
            child: const Align(
                alignment: Alignment.centerLeft, child: Text("ITEM 1")))
      ],
    );
  }
}
