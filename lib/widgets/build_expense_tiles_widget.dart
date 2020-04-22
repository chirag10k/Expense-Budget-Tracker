import 'package:budgetingapp/models/expense_model.dart';
import 'package:budgetingapp/screens/home/expense_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budgetingapp/shared/list.dart';


class BuildExpenseTiles extends StatefulWidget {
  int itemCount;
  bool all;
  int flag;

  BuildExpenseTiles({this.flag = 1, this.itemCount, this.all});

  @override
  _BuildExpenseTilesState createState() => _BuildExpenseTilesState();
}

class _BuildExpenseTilesState extends State<BuildExpenseTiles> {

  DateTime dateTime;
  @override
  Widget build(BuildContext context) {
    if(widget.all == true){
      widget.itemCount = expList.length;
    }
    else if(expList.length <= 5)
      widget.itemCount = expList.length;
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: widget.itemCount,
        itemBuilder: (context, index){
          if(expList[index].timestamp != null)
            dateTime = expList[index].timestamp.toDate();
          return GestureDetector(
            onTap: (){
             if(widget.flag == 1){
               Navigator.push(context, MaterialPageRoute(
                 builder: (context) => ExpensePageScreen(index: index,),
               ));
             }
            },
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                height: MediaQuery.of(context).size.height/9 + 10,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueGrey[900],
                ),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Icon(icons[expList[index].category]?? Icons.arrow_upward, color: Colors.redAccent,),
                    SizedBox(width: 10.0,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          expList[index].expenseMode,
                          style: TextStyle(
                              color: Colors.blue[50],
//                              fontSize: 20.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 5.0,),
                        Text(
                          expList[index].textLabel,
                          style: TextStyle(
                            color: Colors.red[50],
//                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                                '- ',
                                style: TextStyle(color:  Colors.redAccent, fontWeight: FontWeight.bold)
                            ),
                            Text(
                              '₹${expList[index].amount}',
                              style: TextStyle(
                                  color: Colors.blue[50],
//                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        Text(
                          expList[index].category,
                          style: TextStyle(
                            color: Colors.lightBlue[500],
//                            fontSize: 14.0,
                          ),
                        ),
                        (dateTime != null)
                        ? Text(
                          '${DateFormat.MMMd().format(dateTime)}',
                          style: TextStyle(
                            color: Colors.white,
//                            fontSize: 16.0,
                          ),
                        )
                        : SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

