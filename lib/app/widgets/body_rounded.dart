import 'package:flutter/material.dart';

class BodyRounded extends StatelessWidget {
  final Widget child;
  final bool withExpanded;
  final EdgeInsets padding;
  const BodyRounded({Key key, @required this.child, this.withExpanded = false, this.padding = EdgeInsets.zero}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(withExpanded){
      return Expanded(
        child: getContent()
      );
    }
    return getContent();
  }

  Widget getContent(){
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(60),
          topLeft: Radius.circular(60)
        ),
      ),
      child: Padding(
        padding: padding,
        child: child
      )
    );
  }
}