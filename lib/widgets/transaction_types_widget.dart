import 'package:flutter/material.dart';

class TransactionType extends StatefulWidget {
  IconData iconData;
  String type;
  bool selected;


  TransactionType({this.iconData, this.type, this.selected});

  @override
  _TransactionTypeState createState() => _TransactionTypeState();
}

class _TransactionTypeState extends State<TransactionType> {
  @override
  Widget build(BuildContext context) {
    return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    height: 25.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: (widget.selected) ? Colors.black : Colors.white,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        (widget.iconData != null)
        ? Icon(
          widget.iconData,
          color: (widget.type == 'Income') ? Colors.green : (widget.type == 'Expense') ? Colors.red : Colors.blue,
        )
        : SizedBox.shrink(),
        Text(
          widget.type,
          style: TextStyle(
            color: (widget.selected) ? Colors.white : Colors.black,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
  }
}


//Widget transactionTypeWidget (IconData iconData, String type, bool selected){
//  return Container(
//    padding: EdgeInsets.symmetric(horizontal: 10.0),
//    height: 25.0,
//    decoration: BoxDecoration(
//      borderRadius: BorderRadius.circular(20.0),
//      color: Colors.white
//    ),
//    child: Row(
//      crossAxisAlignment: CrossAxisAlignment.center,
//      children: <Widget>[
//        (iconData != null)
//        ? Icon(
//          iconData,
//          color: (type == 'Income') ? Colors.green : Colors.red,
//        )
//        : SizedBox.shrink(),
//        Text(
//          type,
//          style: TextStyle(
//            color: Colors.blue[900],
//            fontSize: 14.0,
//            fontWeight: FontWeight.bold,
//          ),
//        ),
//      ],
//    ),
//  );
//}