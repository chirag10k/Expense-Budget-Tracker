import 'package:budgetingapp/models/income_model.dart';
import 'package:budgetingapp/screens/home/income_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class BuildIncomeTiles extends StatefulWidget {
  int itemCount;
  bool all;
  int flag;

  BuildIncomeTiles({this.flag = 1, this.itemCount, this.all});

  @override
  _BuildIncomeTilesState createState() => _BuildIncomeTilesState();
}

class _BuildIncomeTilesState extends State<BuildIncomeTiles> {

  DateTime dateTime;
  @override
  Widget build(BuildContext context) {
      if(widget.all == true){
        widget.itemCount = incomeList.length;
      }
      else if(incomeList.length <= 5)
        widget.itemCount = incomeList.length;
      return Container(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: widget.itemCount,
          itemBuilder: (context, index){
            if(incomeList[index].timestamp != null)
              dateTime = incomeList[index].timestamp.toDate();
            return GestureDetector(
              onTap: (){
                if(widget.flag == 1) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => IncomePageScreen(index: index,),
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
                      Icon(FontAwesomeIcons.rupeeSign, color: Colors.green,),
                      SizedBox(width: 10.0,),
                      Text(
                        incomeList[index].source,
                        style: TextStyle(
                            color: Colors.blue[50],
//                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                  '+ ',
                                  style: TextStyle(color:  Colors.green, fontWeight: FontWeight.bold)
                              ),
                              Text(
                                '₹${incomeList[index].amount}',
                                style: TextStyle(
                                    color: Colors.blue[50],
//                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          (dateTime != null)
                          ? Text(
                            '${DateFormat.MMMd().format(dateTime)}',
                            style: TextStyle(
                              color: Colors.white,
//                              fontSize: 16.0,
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

