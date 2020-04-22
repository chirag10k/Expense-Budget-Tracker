import 'package:flutter/material.dart';

Widget cardRowDetails(String s1, String s2, Color color){
  return Row(
    children: <Widget>[
      Text(
          s1,
          style: TextStyle(
            color: color,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          )
      ),
      SizedBox(
        width: 20,
      ),
      Text(
        s2,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
      ),
    ],
  );
}