import 'dart:ui';

import 'package:budgetingapp/shared/constants.dart';
import 'package:flutter/material.dart';

//Back Button
Widget backButtonWidget(BuildContext context, Color col) {
  return InkWell(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.arrow_back,
          size: 30.0,
          color: col,
        ),
      ],
    ),
    onTap: (){
      Navigator.pop(context);
    },
  );
}

//Add Button
Widget addButtonWidget(Color col){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(20.0),
      boxShadow: [
        BoxShadow(
          color: Colors.blue,
          blurRadius: 3.0,
          offset: Offset(0.0,2.0),
        )
      ]
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'Add',
          style: formFieldTitleTextStyle.copyWith(decoration: TextDecoration.underline),
        ),
        SizedBox(width: 5.0,),
        Icon(
          Icons.arrow_forward,
          size: 30.0,
          color: col,
        ),
      ],
    ),
  );
}
