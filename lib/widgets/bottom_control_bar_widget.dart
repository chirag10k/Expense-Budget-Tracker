import 'package:budgetingapp/screens/home/add_mode_selection_screen.dart';
import 'package:flutter/material.dart';


  Widget bottomControlBar(BuildContext context) {
    return  Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        color: Colors.blue[50],
        height: 70.0,
        child: Container(
          height: 60,
          width: 60,
          decoration:BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: IconButton(
            icon: Icon(Icons.add),
            iconSize: 40.0,
            color: Colors.white,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => AddModeSelectorScreen(),
              ));
            },
          ),
        ),
      ),
    );
  }
