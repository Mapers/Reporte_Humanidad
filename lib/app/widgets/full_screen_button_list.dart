import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

typedef ActionButtonItem = void Function();

class FullScreenButtonItem extends Equatable{
  final String title;
  final String asssetImage;
  final ActionButtonItem onTap;
  final IconData iconData;

  FullScreenButtonItem({@required this.title, @required this.onTap, this.iconData, this.asssetImage});

  @override
  List<Object> get props => [title, onTap, asssetImage, iconData];
}

class FullScreenButtonList extends StatefulWidget {
  final List<FullScreenButtonItem> items;
  FullScreenButtonList({Key key, @required this.items}) : super(key: key);

  @override
  _FullScreenButtonListState createState() => _FullScreenButtonListState();
}

class _FullScreenButtonListState extends State<FullScreenButtonList> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 60,
          right: 20,
          child: Material(
            color: Colors.transparent,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: getItems()
            ),
          )
        )
      ],
    );
  }

  List<Widget> getItems(){
    List<Widget> children = [];
    int length = widget.items.length;
    int counter = 0;
    widget.items.forEach((item){
      children.add(RaisedButton.icon(
        padding: EdgeInsets.symmetric(horizontal: 10),
        icon: _getIcon(item),
        label: Text(item.title, style: TextStyle(color: Colors.white)),
        onPressed: (){
          Navigator.of(context).pop();
          item.onTap();
        }
      ));
      counter++;
      if(counter != length){
        children.add(SizedBox(height: 5));
      }
    });
    return children;
  }

  Widget _getIcon(FullScreenButtonItem item){
    if(item.iconData == null){
      if(item.asssetImage == null){
        return Icon(Icons.ac_unit, color: Colors.white, size: 18);
      }
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(item.asssetImage))
        )
      );
    }
    return Icon(item.iconData, color: Colors.white, size: 18);
  }
}