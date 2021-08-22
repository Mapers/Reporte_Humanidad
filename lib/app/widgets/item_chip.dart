import 'package:flutter/material.dart';

class ItemChip extends StatelessWidget {
  final String label;
  const ItemChip({Key key, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      padding: EdgeInsets.zero,
      label: Text(label, style: TextStyle(color: Colors.white, fontSize: 12))
    );
  }

}