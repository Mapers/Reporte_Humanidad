import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

class ButtonCloseToFullScreen extends StatelessWidget {
  final double top;
  final double rigth;
  const ButtonCloseToFullScreen({Key key, this.top = 3, this.rigth = 3}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: rigth,
      child: IconButton(
        icon: Icon(FeatherIcons.x),
        onPressed: () => Navigator.of(context).pop()
      )
    );
  }
}